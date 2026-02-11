{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./networking.nix
    ./sound.nix
    ./ssh.nix
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/daniel/.config/sops/age/keys.txt";
  sops.secrets.wifi = { };
  sops.secrets.anthropic_api_key = {
    owner = config.users.users.daniel.name;
  };

  # Enable Yubikeys
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "video"
    ];
    shell = pkgs.zsh;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    allowed-users = [
      "root"
      "daniel"
    ];
  };
  # Gives zsh-autosuggestions suggestions
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh.enable = true;

  console.font = "Lat2-Terminus16";

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      home-manager = inputs.home-manager.packages."${pkgs.system}".default;
    })
  ];

  environment.systemPackages = with pkgs; [
    home-manager
    wget
    evtest # See all inputs
    vim
    git # Need for flakes

    pinentry-curses
    pass
    gnupg # Currently only use for pass, which i only use for gpg, which I only use for vault and proton-bridge...
    protonmail-bridge

    wlsunset # Not yet configured
    udiskie # Mount external drives automatically

    xwayland-satellite
    swaybg
    fuzzel
    swaylock
    swayidle
  ];
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  services.displayManager.gdm.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Fix for some things waylandy

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  hardware.keyboard.qmk.enable = true;
  hardware.graphics.enable = true;

  services.udisks2.enable = true;

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults timestamp_timeout=30
    '';
  };

  systemd.tmpfiles.rules = [
    "Z /etc/nixos 0770 root daniel - -"
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.niri.enable = true;
  # NEVER change.
  system.stateVersion = "24.05";
}
