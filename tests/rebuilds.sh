#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
for host in plank box; do
  nix eval ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath" --raw
  nix eval ".#nixosConfigurations.$host.config.systemd.services.home-manager-daniel.serviceConfig.ExecStart" --raw
  printf '\n'
done
for profile in danielcox daniel.cox; do
  nix eval ".#darwinConfigurations.\"$profile\".system.drvPath" --raw
  printf '\n'
done
