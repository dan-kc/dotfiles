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
    ./notifications.nix
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-colors.homeManagerModules.default
  ];
  colorScheme = inputs.nix-colors.colorSchemes.eighties;

  home.username = "daniel";
  home.homeDirectory = "/home/daniel";
  home.file = {
    ".config/starship.toml".source = ./starship.toml;
    ".config/lazygit/config.yml".source = ./lazygit.yml;
    ".config/atuin/config.toml".source = ./atuin.toml;
    ".config/flavours".source = ./flavours;
  };

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.system}".default;
      # zen = inputs.zen-browser.packages."${pkgs.system}".default;
      # flake-gen = inputs.flake-gen.packages."${pkgs.system}".default;
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
      "claude-code"
      # "cursor"
    ];

  home.packages = with pkgs; [
    (import ./app-launcher.nix { inherit pkgs; })
    (import ./theme.nix { inherit pkgs; })
    flavours
    bruno
    wl-clipboard
    vivaldi
    bemenu
    thunderbird
    protonmail-bridge-gui
    slack
    protonmail-bridge
    postman
    gnumake
    discord
    udiskie
    ddcutil
    brightnessctl
    obsidian
    jt
    anki
    vlc
    neovim
    # zen
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
    gh
    gcc
    bandwhich
    dua
    jq
    just
    miniserve
    rsync
    src-cli
    packer
    unzip
    git-open
    lazygit
    git-filter-repo
    ripdrag
    difftastic
    hurl
    unzip
    ruplacer
    # flake-gen

    pass
    gnupg # Currently only use for pass, which i only use for gpg, which I only use for vault and proton-bridge...
    pinentry-tty
    claude-code
    # code-cursor
    aider-chat
    opencode
  ];
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    diff-so-fancy = {
      enable = true;
      markEmptyLines = true;
    };
    enable = true;
    userName = "Daniel Cox";
    userEmail = "63171098+dan-kc@users.noreply.github.com";
    extraConfig = {
      interactive = {
        singleKey = true;
      };
      init = {
        defaultBranch = "main";
      };
      color = {
        ui = "auto";
      };
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };
    };
  };
  # Never change
  home.stateVersion = "24.05";
}
