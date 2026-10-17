{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ (modulesPath + "/virtualisation/amazon-image.nix") ];

  networking = {
    hostName = "loft";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
      allowPing = false;
    };
  };
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.daniel = import ../../home/loft;
  };
  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    # Bootstrap installs EC2's public key here before activating this system.
    # It persists across rebuilds; this host needs no SOPS decryption identity.
    authorizedKeysFiles = lib.mkForce [ "/var/lib/loft/authorized_keys/%u" ];
    settings = {
      PermitRootLogin = lib.mkForce "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  services.amazon-ssm-agent.enable = lib.mkForce false;
  # User data is a first-install mechanism, never a recurring deployment.
  virtualisation.amazon-init.enable = false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];
  boot.loader.grub.configurationLimit = 5;
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = 1;
      cores = 1;
      auto-optimise-store = true;
      min-free = 1024 * 1024 * 1024;
      max-free = 3 * 1024 * 1024 * 1024;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
  environment.systemPackages = with pkgs; [
    git
    vim
  ];
  systemd.tmpfiles.rules = [ "d /etc/nixos 0755 daniel users - -" ];

  # Initial deployment release; do not change on subsequent upgrades.
  system.stateVersion = "26.05";
}
