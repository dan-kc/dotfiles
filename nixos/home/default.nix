{
  inputs,
  pkgs,
  lib,
  ...
}:
{
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
    ];

  nixpkgs.overlays = [
    (final: prev: {
      hyprland = inputs.hyprland.packages."${pkgs.system}".default;
    })
  ];

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = pkgs.hyprland;
  #   xwayland.enable = true;
  #   # systemd.enable = true;
  # };

  home.packages = with pkgs; [
    clipboard-jh
    wl-clipboard
    vivaldi
    bemenu
    libnotify
    mako
    eww
    hyprpaper
    thunderbird
    slack
    protonmail-bridge
    postman
    gnumake
    go
    tmux
    awscli2
    discord
    eww
    wluma
    hyprshot
  ];

  # Never change
  home.stateVersion = "24.05";
}
