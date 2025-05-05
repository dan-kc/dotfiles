{ config, ... }:

{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowPing = false;
      trustedInterfaces = [ ];
      checkReversePath = true;
    };

    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wifi.path;
      networks = {
        # "Redefined".pskRaw = "ext:COWORK_PSK";
        "M-D-HOME".pskRaw = "ext:HOME";
      };
    };
  };
}
