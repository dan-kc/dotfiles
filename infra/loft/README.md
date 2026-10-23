# loft

NixOS on an ARM `t4g.micro` in London, with one encrypted 30 GiB gp3 root disk
and a fixed public IPv4 address. Only SSH is exposed; outbound IPv4 is unrestricted.
The dev shell includes OpenTofu, AWS CLI, and SSH.

## Deployment

The S3 backend is already provisioned and its state migrated. The SSH key is at
`~/.ssh/loft`; its public key is SOPS-encrypted in `secrets/loft.yaml` for the same
age recipients as your existing secrets. The private SSH key stays on your
workstation. Select AWS credentials with `AWS_PROFILE` if necessary.

From the repository root:

```sh
nix develop
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
tofu -chdir=infra/loft/server init -backend-config=backend.hcl
```

Commit and push the configuration and encrypted public-key file to `main` before launching:
EC2 downloads that public repository at the specified commit.

Find an official NixOS 26.05 ARM image and check it has exactly one EBS device:

```sh
aws ec2 describe-images --region eu-west-2 --owners 427812963091 \
  --filters 'Name=name,Values=nixos/26.05*' 'Name=architecture,Values=arm64' \
  'Name=root-device-type,Values=ebs' 'Name=virtualization-type,Values=hvm' \
  'Name=state,Values=available' \
  --query 'sort_by(Images, &CreationDate)[-1].{AMI:ImageId,Disks:BlockDeviceMappings}'
git rev-parse HEAD
```

Save these inputs in ignored `server/deployment.auto.tfvars.json`, substituting the
image ID and full pushed Git commit. Retain the file for subsequent plans:

```json
{
  "region": "eu-west-2",
  "account_id": "097723411061",
  "ami_id": "ami-REPLACE",
  "git_revision": "REPLACE_WITH_FULL_PUSHED_COMMIT"
}
```

```sh
tofu -chdir=infra/loft/server plan -out=loft.tfplan
tofu -chdir=infra/loft/server apply loft.tfplan
```

The SOPS provider decrypts the public key locally during planning, using your age
identity. No Nix evaluation or public-key environment variable is needed. Only
`secrets/loft.yaml` is read by OpenTofu; keep it limited to this public key because
decrypted data-source values are stored in plans/state. Your existing API secrets
remain in the separate `secrets/secrets.yaml` file.

First boot enables 4 GiB of swap on the root disk, fetches the pinned commit into
`/home/daniel/projects/dotfiles`, and builds and activates `loft` on EC2. Allow time
for this on a small instance. Before switching, bootstrap installs the EC2 metadata
public key into `/var/lib/loft/authorized_keys/daniel`, which sshd reads at runtime. Rebuilds and
reboots preserve that file. Runtime SOPS secrets are decrypted separately using
the server's existing SSH host key. Subsequent reboots do not replay bootstrap.

The checkout lives at `~/projects/dotfiles`. The AMI's original
`/etc/nixos/configuration.nix` stays separate as a bootstrap artifact; routine
rebuilds use the checkout's `loft` flake configuration.

## SSH and updates

Read the SSH host-key fingerprint from authenticated AWS console output before
accepting the first connection:

```sh
aws ec2 get-console-output --region eu-west-2 --latest \
  --instance-id "$(tofu -chdir=infra/loft/server output -raw instance_id)" \
  --query Output --output text
tofu -chdir=infra/loft/server output -raw ssh_command
```

Run the displayed SSH command and compare its fingerprint with the console output.
Once connected:

```sh
cd /home/daniel/projects/dotfiles
git pull --ff-only
sudo nixos-rebuild switch --flake .#loft
# Roll back if needed:
sudo nixos-rebuild switch --rollback
```

`daniel` has passwordless sudo. Root and password SSH logins are disabled after
bootstrap. Weekly garbage collection removes generations older than 14 days;
five boot entries are retained. Keep `system.stateVersion` at `26.05` on upgrades.

Fail2ban watches SSH authentication failures and bans an address for one hour
after five failures within ten minutes. Inspect it with
`sudo fail2ban-client status sshd`; unban an address with
`sudo fail2ban-client set sshd unbanip ADDRESS`.

The loft Home Manager profile is applied by the same `nixos-rebuild switch`.
It provides Zsh, a Starship prompt that always shows `@loft`, the shared colours
and fonts, Yazi, lazygit, Pi and Codex. Fonts used to render SSH sessions
still come from your local terminal.

## T3 Code on iPhone

The rebuild also starts the `t3code` systemd user service as `daniel`. Lingering
keeps it running after SSH logout and starts it at boot. It waits for Tailscale
to have an IPv4 address, then binds HTTP/WebSocket port 3773 to that address.
The NixOS firewall allows this port only on `tailscale0`; no public T3 port or
T3 Connect relay is needed. Your tailnet policy must allow the phone to reach
`loft:3773`.

On loft, after pulling and rebuilding:

```sh
systemctl --user status t3code
tailscale ip -4
t3 pair
```

Connect the iPhone's Tailscale app to the same tailnet. In T3 Code, choose
**Add environment**, then scan the QR code printed by `t3 pair`, or enter the
Tailscale IPv4 address followed by `:3773` in **Address** and the fresh pairing
code in **Code**. A pairing link is a credential; generate a new one for each
device. In the paired app, add a project from loft's `~/projects` directory.

Pi and Codex are enabled automatically with the Nix-managed binaries. Pi uses
the existing `~/.pi/agent` configuration and the OpenRouter key loaded from
`/run/secrets/openrouter_api_key`. Codex uses daniel's existing CLI credentials;
if not already authenticated, run `codex login --device-auth` on loft and finish
the login in your phone's browser. T3 starts its own provider processes; the
separate `codex-app-server` service remains available for SSH clients.

Inspect startup/provider failures with `journalctl --user -u t3code -n 100`.
After rotating the OpenRouter key, run `systemctl --user restart t3code`.
If Tailscale is not authenticated, run `sudo tailscale up` once; the service
retries automatically. T3 stores threads, pairings and settings in `~/.t3`.
On service startup, the two managed provider entries are refreshed while other
settings are preserved.

The CLI is pinned in `pkgs/t3code/default.nix` to the upstream 0.1.2 headless
archive, with its checksum and NixOS ELF fixes. This avoids compiling the
desktop application on the micro instance. Update the version and archive
checksums there and rebuild to upgrade; use Nix to manage this installation
instead of `t3 update` or `t3 service install`. Client and server orchestration
protocols must match; if the phone requests a newer server, update this pin.

## Runtime secrets

OpenRouter is stored in `secrets/loft-runtime.yaml`, encrypted for plank, box and
loft's SSH host key. Edit it with `nix develop -c sops secrets/loft-runtime.yaml`,
commit and pull the change on loft, then rebuild. Sops-nix installs it at
`/run/secrets/openrouter_api_key`, owned by `daniel` with mode `0400`. A new
interactive Zsh session exports it as `OPENROUTER_API_KEY`; restart existing
agents to pick up a rotated key. This file is never read by OpenTofu.

If loft is replaced, its new SSH host key must be converted with `ssh-to-age`,
the loft recipient in `.sops.yaml` updated, and `sops updatekeys
secrets/loft-runtime.yaml` run from an existing recipient machine before the
new host can activate this configuration. Keep a workstation recipient for
recovery; do not copy a workstation's age private key onto loft.

For key rotation, add the new public key to `/var/lib/loft/authorized_keys/daniel`
on the server using sudo, then verify a second session before removing the old
key. Edit `secrets/loft.yaml` with `sops` and apply the OpenTofu change for future
launches. Changing SOPS or the EC2 key pair alone does not rotate an existing
instance's login key. Keep the server's authorized-key file root-owned and mode 0644.

## Backend and recovery

Both OpenTofu roots use the existing versioned, encrypted S3 bucket with native
locking. Their checked-in `backend.hcl` files contain identifiers, not credentials.
To maintain the backend itself:

```sh
export TF_VAR_region=eu-west-2
export TF_VAR_account_id=097723411061
export TF_VAR_bucket_name=loft-tfstate-097723411061-eu-west-2
tofu -chdir=infra/loft/backend init -backend-config=backend.hcl
tofu -chdir=infra/loft/backend plan
```

If first boot fails before activation, connect as `root` with the same key and
inspect `journalctl -u amazon-init` and `/var/log/loft-bootstrap.log`. Retry with
`systemctl restart amazon-init`. After activation, use `daniel` and sudo.

Instance replacement/deletion and backend deletion are blocked by `prevent_destroy`.
For deliberate replacement, back up your data, select a current official AMI,
remove the instance protection, and review the plan. Deleting the instance deletes
its sole disk. No backups are provisioned. The Elastic IP can be retained across
replacement. Old launch AMIs may expire without affecting existing instances.

Billing includes EC2, EBS, public IPv4, S3 state storage/requests, and applicable
data transfer. Standard CPU credits avoid surplus-credit charges but can throttle
long builds. Stopping EC2 does not stop disk or Elastic IP charges.
