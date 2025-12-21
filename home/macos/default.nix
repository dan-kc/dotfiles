{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ];
  home.username = "danielcox";
  home.homeDirectory = "/Users/danielcox";

  home.file = {
    "Library/Application\ Support/lazygit/config.yml".source = ../common/lazygit.yml;
  };


  # Allow home-manager to manage home-manager.
  programs.home-manager.enable = true;
}
