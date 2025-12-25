{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./yazi
    ./hyprland
    ./notifications.nix
    ./niri.nix
    inputs.sops-nix.homeManagerModules.sops
    inputs.zen-browser.homeModules.twilight
  ];

  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  home.file = {
    ".config/lazygit/config.yml".source = ../common/lazygit.yml;
  };

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
    kdePackages.kdenlive
    anki
    bemenu
    brightnessctl
    ddcutil
    discord
    protonmail-desktop
    gcc
    lsof
    obsidian
    pinentry-tty
    protonmail-bridge
    protonmail-bridge-gui
    ripdrag
    slack

    thunderbird
    trash-cli
    udiskie
    unzip
    vivaldi
    ffmpeg-full # For vivaldi playback
    vlc
    vscode
    wl-clipboard
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

  programs.obs-studio = {
    enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };
}
