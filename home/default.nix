{
  inputs,
  pkgs,
  lib,
  config,
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
    # inputs.zen-browser.homeModules.twilight
  ];
  # https://github.com/tinted-theming/base16-schemes
  # colorScheme = inputs.nix-colors.colorSchemes.kanagawa;
  # colorScheme = inputs.nix-colors.colorSchemes.ashes;
  # colorScheme = inputs.nix-colors.colorSchemes.atelier-cave;
  # colorScheme = inputs.nix-colors.colorSchemes.atelier-forest; 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.atlas; 5/10
  colorScheme = inputs.nix-colors.colorSchemes.ayu-dark;

  home.username = "daniel";
  home.homeDirectory = "/home/daniel";
  home.file = {
    ".config/starship.toml".source = ./starship.toml;
    ".config/lazygit/config.yml".source = ./lazygit.yml;
    ".config/atuin/config.toml".source = ./atuin.toml;
    ".config/theme.yaml".text = ''
      base00: "${config.colorScheme.palette.base00}"
      base01: "${config.colorScheme.palette.base01}"
      base02: "${config.colorScheme.palette.base02}"
      base03: "${config.colorScheme.palette.base03}"
      base04: "${config.colorScheme.palette.base04}"
      base05: "${config.colorScheme.palette.base05}"
      base06: "${config.colorScheme.palette.base06}"
      base07: "${config.colorScheme.palette.base07}"
      base08: "${config.colorScheme.palette.base08}"
      base09: "${config.colorScheme.palette.base09}"
      base0A: "${config.colorScheme.palette.base0A}"
      base0B: "${config.colorScheme.palette.base0B}"
      base0C: "${config.colorScheme.palette.base0C}"
      base0D: "${config.colorScheme.palette.base0D}"
      base0E: "${config.colorScheme.palette.base0E}"
      base0F: "${config.colorScheme.palette.base0F}"
    '';
  };

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.system}".default;
      flake-gen = inputs.flake-gen.packages."${pkgs.system}".default;
      jt = inputs.jt.packages."${pkgs.system}".default;
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
    ];

  home.packages = with pkgs; [
    (import ./app-launcher.nix { inherit pkgs; })
    (import ./theme.nix { inherit pkgs; })
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
    flake-gen

    pass
    gnupg # Currently only use for pass, which i only use for gpg, which I only use for vault and proton-bridge...
    pinentry-tty
    claude-code
    aider-chat
    opencode
    jujutsu
    delta
    qpdf
  ];
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  # programs.zen-browser = {
  #   enable = true;
  #   policies = {
  #     AutofillAddressEnabled = false;
  #     AutofillCreditCardEnabled = false;
  #     DisableAppUpdate = true;
  #     DisableFeedbackCommands = true;
  #     DisableFirefoxStudies = true;
  #     DisablePocket = true;
  #     DisableTelemetry = true;
  #     DontCheckDefaultBrowser = true;
  #     NoDefaultBookmarks = true;
  #     OfferToSaveLogins = false;
  #     EnableTrackingProtection = {
  #       Value = true;
  #       Locked = true;
  #       Cryptomining = true;
  #       Fingerprinting = true;
  #     };
  #   };
  # };
  #
  # xdg.mimeApps =
  #   let
  #     value =
  #       let
  #         zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
  #       in
  #       zen-browser.meta.desktopFileName;
  #
  #     associations = builtins.listToAttrs (
  #       map
  #         (name: {
  #           inherit name value;
  #         })
  #         [
  #           "application/x-extension-shtml"
  #           "application/x-extension-xhtml"
  #           "application/x-extension-html"
  #           "application/x-extension-xht"
  #           "application/x-extension-htm"
  #           "x-scheme-handler/unknown"
  #           "x-scheme-handler/mailto"
  #           "x-scheme-handler/chrome"
  #           "x-scheme-handler/about"
  #           "x-scheme-handler/https"
  #           "x-scheme-handler/http"
  #           "application/xhtml+xml"
  #           "application/json"
  #           "text/plain"
  #           "text/html"
  #         ]
  #     );
  #   in
  #   {
  #     associations.added = associations;
  #     defaultApplications = associations;
  #   };
  #

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
