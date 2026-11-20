{ pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ./fonts.nix
    ./ghostty.nix
    ./skills.nix
    ./trash.nix
  ];

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-30 days";
  };

  home.packages = [ pkgs.gh ];

  # Never change
  home.stateVersion = "24.05";
}
