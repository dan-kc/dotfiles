#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
for host in plank box; do
  nix eval ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath" --raw
  nix eval ".#nixosConfigurations.$host.config.systemd.services.home-manager-daniel.serviceConfig.ExecStart" --raw
  printf '\n'
done
for profile in danielcox daniel.cox; do
  test "$(nix eval ".#homeConfigurations.\"$profile\".config.programs.home-manager.enable")" = true
  nix eval ".#homeConfigurations.\"$profile\".activationPackage.drvPath" --raw
  printf '\n'
done
