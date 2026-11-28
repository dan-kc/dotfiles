What are you doing here?

## Mac mini

The `mac-mini` nix-darwin configuration manages the Tailscale system daemon,
power settings, Git and GitHub CLI. Home Manager configures Codex, Claude Code
and Pi for `daniel`.

Install Nix once using the official multi-user installer from
[nixos.org](https://nixos.org/download/#nix-install-macos). From the dotfiles
checkout on the Mac, build and activate the first generation.

```sh
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
rebuild=$(nix --extra-experimental-features 'nix-command flakes' build \
  --no-link --print-out-paths .#darwinConfigurations.mac-mini.config.system.build.darwin-rebuild)
sudo "$rebuild/bin/darwin-rebuild" switch --flake .#mac-mini
```

For later changes, run `sudo darwin-rebuild switch --flake .#mac-mini` from
the checkout. Enroll the system daemon once and open the authorization link.
The explicit socket selects the daemon while the standalone app's extension
is still loaded. GitHub and the agent CLIs have their own sign-in steps.

```sh
sudo tailscale --socket=/var/run/tailscaled.socket up --hostname=mac-mini
tailscale --socket=/var/run/tailscaled.socket ip -4
```

The Mac uses macOS Remote Login and Screen Sharing. Both can serve connections
at the macOS login window. In RealVNC Viewer, use the Mac's new Tailscale IP
and the existing VNC password. For a connection tunneled through SSH,
forward port 5900 and point the viewer to `localhost:5900`.

```sh
ssh -F ~/.ssh/config -N -L 5900:localhost:5900 daniel@<tailscale-ip>
```

With FileVault on, a cold boot stops at disk unlock. On Apple silicon with
macOS 26 or later, use LAN SSH to unlock the disk. The Tailscale daemon and
Screen Sharing start after macOS boots.

## Shared drive

The Mac mini hosts a 40 GiB drive for every device on the tailnet. Tailscale
must be on for the device to reach it. Every device uses the same login: the
user name is `drive`, and the password is in sops.

```sh
sops -d --extract '["drive_password"]' secrets/mac-mini.yaml
```

- **iPhone:** Files → Browse → ⋯ → Connect to Server →
  `smb://mac-mini.tailee0aac.ts.net` → Registered User → `drive` and the
  password → open `Drive`.
- **Mac:** in Finder, press Cmd+K and enter `smb://mac-mini.tailee0aac.ts.net`.
  The WebDAV address `https://mac-mini.tailee0aac.ts.net:8446` also works.
- **Linux:** `sudo mount -t cifs //mac-mini.tailee0aac.ts.net/Drive /mnt/drive -o username=drive,uid=$(id -u),gid=$(id -g)`,
  or mount the WebDAV address with davfs2.
- **Size:** the drive holds 40 GiB in total, whichever way files arrive.
  Changing the size is covered below.

### How it works

`system/mac-mini/drive.nix` declares everything. The files live in a sparse disk
image, `/Library/Drive/Drive.sparsebundle`. The `dev.keone.drive-volume` daemon
creates the image on first run, keeps it mounted at `/Library/Drive/Volume`, and
checks every 30 seconds that it's still attached, re-attaching it if not. If the
image goes missing after the first run, the daemon refuses to create an empty
replacement. Both servers share `/Library/Drive/Volume/files`, which exists only
on the mounted volume. The mount point belongs to root, so an unmounted volume can never pass for an empty
share. WebDAV answers 503 and SMB refuses to connect until the volume is back.

- **Quota:** the image's APFS container is the limit, 40 GiB (42.7 GB). Writes
  past it fail over either protocol. SMB reports a full disk, and WebDAV returns
  a server error. WebDAV stages uploads on the volume, so a half-finished
  upload also counts against the limit.
- **WebDAV:** the `dev.keone.drive-webdav` daemon runs nginx on
  `127.0.0.1:4790`, with Basic auth. Its workers run as `drive`, which can't
  read the password secret. nginx refuses symlinks, deleting the share root, and
  any COPY or MOVE onto it. `tailscale serve` publishes it on the tailnet as `https://mac-mini.tailee0aac.ts.net:8446`.
- **SMB:** macOS File Sharing serves the `Drive` share to the hidden `drive`
  account. Activation sets that account's password from sops. `drive` has no
  shell and is denied SSH, and guest access is off. Activation also turns SMB
  off for the default Public folder share.

macOS File Sharing listens on every interface, so interface binding can't keep
it off the LAN. The `dev.keone.drive-firewall` daemon loads a pf anchor
(`com.apple/drive-smb`) that accepts SMB only from loopback and Tailscale
addresses and drops it from everything else. Devices on the LAN may still see
the Mac advertised over Bonjour, but they can't connect. To check the rules:
`sudo pfctl -a com.apple/drive-smb -s rules`.

The tailnet policy decides which devices reach the drive. Grants add up, so
this only narrows access if no broader grant covers the Mac. To limit the drive
to your own login (replace `you@example.com`):

```json
"hosts": { "mac-mini": "100.75.235.107", "mac-mini-v6": "<tailscale ip -6>" },
"grants": [
  { "src": ["you@example.com"], "dst": ["mac-mini", "mac-mini-v6"], "ip": ["tcp:445", "tcp:8446"] }
]
```

To change the password, edit `drive_password` with `sops secrets/mac-mini.yaml`
and rebuild. To resize the drive, detach it, resize the image, and re-attach it.
Clients see the drive as unavailable for the duration. Shrinking only works down
to the space already in use. Also set `size` in `drive.nix`, which applies when
the image is created.

```sh
sudo launchctl bootout system/org.nixos.dev.keone.drive-volume
sudo hdiutil detach /Library/Drive/Volume
sudo hdiutil resize -size 60g /Library/Drive/Drive.sparsebundle
sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.dev.keone.drive-volume.plist
```

WebDAV locks and SMB file locks don't know about each other, so don't edit the
same file from both protocols at once.

Nothing backs up the drive. Deleted files don't shrink the image on disk, and
`hdiutil compact` (with the image detached) reclaims that space. Back up the
files under `/Library/Drive/Volume/files`, not the mounted image. If the Mac's
own disk fills up first, writes to the drive fail even though it shows free
space.

On the NixOS hosts, a WebDAV mount looks like this:

```nix
services.davfs2.enable = true;
fileSystems."/mnt/drive" = {
  device = "https://mac-mini.tailee0aac.ts.net:8446/";
  fsType = "davfs";
  options = [ "_netdev" "noauto" "user" "x-systemd.automount" ];
};
```

Put `/mnt/drive drive <password>` in `/etc/davfs2/secrets` (mode 600).
