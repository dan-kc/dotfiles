{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/amazon-image.nix")
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/loft-runtime.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [ ];
    secrets.openrouter_api_key = {
      owner = "daniel";
      mode = "0400";
    };
  };

  networking = {
    hostName = "loft";
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      interfaces.tailscale0.allowedTCPPorts = [
        22
        3773 # T3 Code HTTP/WebSocket access from the tailnet only.
      ];
      allowPing = false;
    };
  };
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.daniel = {
    isNormalUser = true;
    linger = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  programs.git = {
    enable = true;
    # Root rebuilds from the checkout maintained by daniel.
    config.safe.directory = "/home/daniel/projects/dotfiles";
  };
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.daniel = import ../../home/loft;
  };
  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    openFirewall = false;
    # Bootstrap installs EC2's public key here before activating this system.
    # It persists across rebuilds independently of runtime SOPS secrets.
    authorizedKeysFiles = lib.mkForce [ "/var/lib/loft/authorized_keys/%u" ];
    settings = {
      # SwiftNIOSSH requires a shared MAC name even when using AES-GCM.
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-256"
      ];
      PermitRootLogin = lib.mkForce "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  services.amazon-ssm-agent.enable = lib.mkForce false;
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--accept-dns=false" ];
  };
  # The NixOS module enables the SSH jail when OpenSSH is enabled.
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    jails.sshd.settings.findtime = "10m";
  };
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
    # SSH carries TERM=xterm-ghostty; Zsh needs its cursor/erase capabilities.
    ghostty.terminfo
    git
    vim
  ];
  systemd.tmpfiles.rules = [
    "d /home/daniel/projects 0755 daniel users - -"
    "d /home/daniel/projects/dotfiles 0755 daniel users - -"
    # The iPhone SSH bootstrap probes uname with PATH=/usr/bin:/bin.
    "L+ /usr/bin/uname - - - - ${pkgs.coreutils}/bin/uname"
  ];

  # Initial deployment release; do not change on subsequent upgrades.
  system.stateVersion = "26.05";
}
