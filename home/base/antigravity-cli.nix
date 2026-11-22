{ pkgs, ... }:
{
  nixpkgs.config.allowUnfreePackages = [ "antigravity-cli" ];
  home.packages = [ pkgs.antigravity-cli ];
  # The store copy is read-only; updates come from nixpkgs.
  home.sessionVariables.AGY_CLI_DISABLE_AUTO_UPDATE = "true";
}
