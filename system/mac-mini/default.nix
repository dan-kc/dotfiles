{ pkgs, ... }:
{
  imports = [
    ./app-services.nix
    ./drive.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "daniel";
  users.users.daniel.home = "/Users/daniel";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  sops.age = {
    keyFile = "/Users/daniel/.config/sops/age/keys.txt";
    sshKeyPaths = [ ];
  };
  sops.gnupg.sshKeyPaths = [ ];
  sops.secrets.openrouter_api_key = {
    sopsFile = ../../secrets/mac-mini.yaml;
    owner = "daniel";
  };

  environment.systemPackages = with pkgs; [
    gh
    git
    tmux
  ];

  # macOS zsh reads this database before loading shell startup files.
  home-manager.users.daniel.home.file.".terminfo/78/xterm-ghostty".source =
    "${pkgs.ghostty-bin.terminfo}/share/terminfo/78/xterm-ghostty";

  home-manager.users.daniel.home.packages = [
    pkgs.ffmpeg
    pkgs.nodejs
    (pkgs.callPackage ../../pkgs/agent-device { })
  ];

  services.tailscale.enable = true;
  launchd.daemons.tailscaled.serviceConfig.KeepAlive = true;
  # tailscaled manages this resolver and rejects symlinks outside /etc/resolver.
  environment.etc."resolver/ts.net".enable = false;

  system.activationScripts.postActivation.text = ''
    /usr/bin/pmset -c sleep 0 autorestart 1
  '';
}
