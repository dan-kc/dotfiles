{
  pkgs,
  inputs,
  ...
}:
let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./networking.nix
    ./sound.nix
    ./ssh.nix
    # inputs.sops-nix.nixosModules.sops
  ];
  # sops.defaultSopsFile = ../secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";
  # sops.age.keyFile = "/home/daniel/.config/sops/age/keys.txt";
  # sops.secrets."wifi.env" = { };

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

  nixpkgs.config.allowUnfree = true;

  console.font = "Lat2-Terminus16";

  virtualisation.docker.enable = true;

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
    qmk

    # Not yet configured
    wlsunset
  ];

  hardware.keyboard.qmk.enable = true;

  programs.zsh.enable = true;

  # # Hyprland stuff
  # programs.hyprland = {
  #   enable = true;
  #   # set the flake package
  #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #   # make sure to also set the portal package, so that they are in sync
  #   portalPackage =
  #     inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  #   xwayland.enable = true;
  # };
  # hardware.graphics = {
  #   # Needed else you may get stuttering. The Mesa version needs to be the
  #   # same as the flake.
  #   package = pkgs-hyprland.mesa;
  #   # driSupport32Bit = true;
  #   package32 = pkgs-hyprland.pkgsi686Linux.mesa;
  # };

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
