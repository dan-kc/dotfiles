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
`/etc/nixos`, and builds and activates `loft` on EC2. Allow time for this on a small
instance. Before switching, bootstrap installs the EC2 metadata public key into
`/var/lib/loft/authorized_keys/daniel`, which sshd reads at runtime. Rebuilds and
reboots preserve that file; the server receives no age private key and does not
decrypt SOPS files. Subsequent reboots do not replay bootstrap.

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
cd /etc/nixos
git pull --ff-only
sudo nixos-rebuild switch --flake .#loft
# Roll back if needed:
sudo nixos-rebuild switch --rollback
```

`daniel` has passwordless sudo. Root and password SSH logins are disabled after
bootstrap. Weekly garbage collection removes generations older than 14 days;
five boot entries are retained. Keep `system.stateVersion` at `26.05` on upgrades.

The loft Home Manager profile is applied by the same `nixos-rebuild switch`.
It provides Zsh, a Starship prompt that always shows `@loft`, the shared colours
and fonts, Yazi, lazygit, Herdr, Pi and Codex. Agent credentials are not installed;
authenticate on loft when ready. Fonts used to render SSH sessions still come
from your local terminal.

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
