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
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.x86_64-linux.hyprland;
  };

  console.font = "Lat2-Terminus16";

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      home-manager = inputs.home-manager.packages."${pkgs.system}".default;
      hyprcursor = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
    })
  ];

  environment.systemPackages = with pkgs; [
    home-manager
    wget
    evtest # See all inputs
    vim
    git # Need for flakes

    wlsunset # Not yet configured
    udiskie # Mount external drives automatically
    hyprcursor
  ];

  hardware.keyboard.qmk.enable = true;

  services.udisks2.enable = true;

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults timestamp_timeout=30
    '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  systemd.tmpfiles.rules = [
    "Z /etc/nixos 0770 root daniel - -"
  ];

  # NEVER change.
  system.stateVersion = "24.05";
}
