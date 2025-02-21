{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./cli
    ./fonts.nix
  ];

  home.sessionVariables = {
    SRC_ENDPOINT = "https://sourcegraph.com";
  };

  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  home.file = {
    ".config/alacritty.toml".source = ./alacritty.toml;
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/wezterm".source = ./wezterm;
    ".local/bin".source = ./scripts;
    ".config/waybar".source = ./waybar;
  };
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vivaldi"
      "slack"
      "postman"
      "packer"
      "discord"
    ];

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.system}".default;
    })
    (final: prev: {
      wezterm = inputs.wezterm.packages."${pkgs.system}".default;
    })
    (final: prev: {
      zen = inputs.zen-browser.packages."${pkgs.system}".default;
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
    alacritty
    wezterm
    anki
    vlc
    thunderbird
    slack
    protonmail-bridge
    postman
    neovim
    gnumake
    go
    tmux
    awscli2
    discord
    zen
    waybar
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # TODO:
  ### systemd.user.services.ollama.enable = true;

  # Never change
  home.stateVersion = "24.05";
}
