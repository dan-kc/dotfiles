{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ 
    ./wezterm.nix
  ];
  home.username = "danielcox";
  home.homeDirectory = "/Users/danielcox";

  home.file = {
    "Library/Application\ Support/lazygit/config.yml".source = ../common/lazygit.yml;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

  # Allow home-manager to manage home-manager.
  programs.home-manager.enable = true;
}
