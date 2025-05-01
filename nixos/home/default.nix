{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ inputs.hy3.packages.x86_64-linux.hy3 ];
    xwayland.enable = true;
  };

  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  home.file = {
    ".config/hypr".source = ./hyprland;
    ".config/eww".source = ./eww;
    "wluma/config.toml".source = ./wluma.toml;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vivaldi"
      "slack"
      "postman"
      "packer"
      "discord"
      "libsciter"
      "obsidian"
    ];

  home.packages = with pkgs; [
    bruno
    yaak
    clipboard-jh
    wl-clipboard
    vivaldi
    bemenu
    libnotify
    mako
    eww
    hyprpaper
    hyprshot
    thunderbird
    slack
    protonmail-bridge
    postman
    gnumake
    tmux
    awscli2
    discord
    eww
    wluma
    udiskie
    matugen
    obsidian
  ];

  # Never change
  home.stateVersion = "24.05";
}
