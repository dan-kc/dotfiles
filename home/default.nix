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
    inputs.zen-browser.homeModules.twilight
  ];
  # https://github.com/tinted-theming/base16-schemes
  # colorScheme = inputs.nix-colors.colorSchemes.kanagawa;
  # colorScheme = inputs.nix-colors.colorSchemes.ashes;
  # colorScheme = inputs.nix-colors.colorSchemes.atelier-cave;
  # colorScheme = inputs.nix-colors.colorSchemes.atelier-forest; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.atlas; # 5/10
  # colorScheme = inputs.nix-colors.colorSchemes.ayu-dark; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.blueforest; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.codeschool;  # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.danqing; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.darcula; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.darkmoss; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.darktooth; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.decaf; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.dracula; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.eighties; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.eris; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.espresso; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.eva; # 8/10
  colorScheme = inputs.nix-colors.colorSchemes.everforest; # 9/10

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
      tv = inputs.television.packages."${pkgs.system}".default;
    })
  ];
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "discord"
      "libsciter"
      "obsidian"
      "packer"
      "postman"
      "slack"
      "vivaldi"
      "vscode"
    ];

  home.packages = with pkgs; [
    (import ./app-launcher.nix { inherit pkgs; })
    (import ./theme.nix { inherit pkgs; })
    aider-chat
    anki
    bandwhich
    bemenu
    brightnessctl
    bruno
    claude-code
    ddcutil
    tv
    delta
    difftastic
    discord
    dua
    eza
    fd
    nushell
    imagemagick
    protonmail-desktop
    flake-gen
    fzf
    gcc
    gh
    git-filter-repo
    git-open
    google-cloud-sdk
    hurl
    jt
    jujutsu
    lazydocker
    lazygit
    lsof
    neovim
    obsidian
    opencode
    pinentry-tty
    postman
    protonmail-bridge
    protonmail-bridge-gui
    qpdf
    ripdrag
    ripgrep
    rsync
    ruplacer
    slack
    src-cli
    starship
    thunderbird
    trash-cli
    tree
    udiskie
    unzip
    vivaldi
    ffmpeg-full # For vivaldi playback
    vlc
    vscode
    wl-clipboard
    yt-dlp
    zoxide
  ];
  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    profiles.default = {
      isDefault = true;

      # Here’s the important part:
      settings = {
        "media.cubeb.backend" = "pulse";
      };
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        proton-pass
        df-youtube
      ];
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
  programs.obs-studio = {
    enable = true;
  };

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      markEmptyLines = true;
    };
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Daniel Cox";
        email = "63171098+dan-kc@users.noreply.github.com";
      };
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
