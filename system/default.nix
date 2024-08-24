{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./sound.nix
    ./ssh.nix
  ];

  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’.
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

  console = {
    font = "Lat2-Terminus16";
    #   keyMap = "gb";
  };

  virtualisation.docker.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Configured to perfect state
    wget # Tool for retrieving files
    evtest # See all inputs
    vim

    # Not yet configured
    wlsunset
  ];

  programs.zsh.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.ollama.enable = true;
  security.sudo = {
    enable = true;
    extraConfig = ''
      # User privilege specification
      Defaults timestamp_timeout=20
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
