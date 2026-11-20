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
