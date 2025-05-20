{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./fonts.nix
    ./alacritty.nix
    ./zsh
    ./yazi
    ./hyprland
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-colors.homeManagerModules.default
  ];
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;

  home.username = "daniel";
  home.homeDirectory = "/home/daniel";
  home.file = {
    ".config/starship.toml".source = ./starship.toml;
    ".config/lazygit/config.yml".source = ./lazygit.yml;
    ".config/atuin/config.toml".source = ./atuin.toml;
    ".config/wezterm".source = ./wezterm;
    ".config/direnv/direnv.toml".source = ./direnv.toml;
  };

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.system}".default;
      wezterm = inputs.wezterm.packages."${pkgs.system}".default;
      zen = inputs.zen-browser.packages."${pkgs.system}".default;
      flake-gen = inputs.flake-gen.packages."${pkgs.system}".default;
      jt = inputs.jt.packages."${pkgs.system}".default;
      flavours = inputs.flavours.packages."${pkgs.system}".default;
    })
  ];
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
    (import ./app-launcher.nix { inherit pkgs; })
    flavours
    bruno
    yaak
    wl-clipboard
    vivaldi
    bemenu
    libnotify
    mako
    thunderbird
    slack
    protonmail-bridge
    postman
    gnumake
    tmux
    awscli2
    discord
    udiskie
    ddcutil
    brightnessctl
    matugen
    obsidian
    jt
    anki
    vlc
    wezterm
    neovim
    zen
    atuin
    tree
    fzf
    lazydocker
    eza
    fd
    ripgrep
    zoxide
    starship
    trash-cli
    k3s
    gh
    fnm
    gcc
    bandwhich
    dua
    jq
    just
    miniserve
    rsync
    src-cli
    opentofu
    packer
    unzip
    git-open
    lazygit
    git-filter-repo
    ripdrag
    difftastic
    pass
    gnupg # Currently only use for pass, which i only use for gpg, which I only use for vault...
    hurl
    unzip
    direnv
    ruplacer
    flake-gen
  ];

  programs.git = {
    enable = true;
    userName = "Daniel Cox";
    userEmail = "63171098+dan-kc@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      color = {
        ui = "auto";
      };
    };
  };
  # Never change
  home.stateVersion = "24.05";
}
