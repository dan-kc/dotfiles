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
    EDITOR = "nvim";
  };

  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  home.file = {
    ".config/alacritty.toml".source = ./alacritty.toml;
    ".config/hypr".source = ./hyprland;
    ".config/wezterm".source = ./wezterm;
    ".local/bin".source = ./scripts;
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
      neovim = inputs.neovim.packages."${pkgs.system}".default;
    })
    (final: prev: {
      wezterm = inputs.wezterm.packages."${pkgs.system}".default;
    })
    (final: prev: {
      zen = inputs.zen-browser.packages."${pkgs.system}".default;
    })
    (final: prev: {
      yazi = inputs.yazi.packages."${pkgs.system}".default;
    })
    inputs.rust-overlay.overlays.default
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
    eww
    wluma
    pyprland
    yazi
    rust-bin.stable.latest.default
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # TODO:
  ### systemd.user.services.ollama.enable = true;

  # Never change
  home.stateVersion = "24.05";
}
