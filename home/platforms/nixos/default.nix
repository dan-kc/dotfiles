{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./notifications.nix
    ./niri.nix
    ./fuzzel.nix
    ./battery-watch.nix
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.file = {
    ".config/lazygit/config.yml".source = ../../base/lazygit.yml;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "todoist-electron"
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
    kdePackages.kdenlive
    anki
    bemenu
    brightnessctl
    ddcutil
    gcc
    handy
    lsof
    nautilus
    obsidian
    pinentry-tty
    ripdrag
    slack
    todoist-electron

    trash-cli
    udiskie
    unzip
    # Proprietary codecs required for web video/audio (YouTube, Reddit, etc.)
    (vivaldi.override { proprietaryCodecs = true; })
    vlc
    wl-clipboard
    wtype
  ];

  systemd.user.services.handy = {
    Unit = {
      Description = "Handy speech-to-text";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.handy}/bin/handy --start-hidden";
      Environment = "PATH=${lib.makeBinPath [ pkgs.wtype pkgs.wl-clipboard ]}:/run/current-system/sw/bin";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  programs.obs-studio = {
    enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/slack" = "slack.desktop";
    };
  };
}
