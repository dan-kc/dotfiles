{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.wireless.enable = lib.mkForce false;
  networking.hostName = "box";

  # SSH is reachable on the host's normal network interfaces.
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Serve the share only over Tailscale; authenticate as the existing daniel user.
  services.samba = {
    enable = true;
    openFirewall = false;
    settings = {
      global."server min protocol" = "SMB2";
      share = {
        path = "/srv/samba/share";
        browseable = "yes";
        "read only" = "no";
        "valid users" = "daniel";
        "force user" = "daniel";
        "create mask" = "0660";
        "directory mask" = "0770";
      };
    };
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 445 ];
  systemd.tmpfiles.rules = [ "d /srv/samba/share 0770 daniel users - -" ];
}
