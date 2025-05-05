What are you doing here?

# Enable a new device to decrypt ssh secrets

## Generate age key from an ssh key

- ssh-to-age -- -private-key -i ~/.ssh/age > ~/.config/sops/age/keys.txt

## Get public version of the key

- age -c age-keygen -y ~/.config/sops/age/keys.txt

Add the key to sops.yaml, then modify and regenrate the secrets.

# Todo:

- theming / wallpapers (mutagen)
- tmux
- airpods
- faster zoom in/out
