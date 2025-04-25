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

  # We dont use this....
  nixpkgs.overlays = [
    (final: prev: {
      hyprland = inputs.hyprland.packages."${pkgs.system}".default;
    })
  ];

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
    udiskie
  ];

  # Never change
  home.stateVersion = "24.05";
}
