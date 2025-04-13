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
      secretsFile = config.sops.secrets."wifi.env".path;
      networks = {
        "Redefined".pskRaw = "ext:COWORK_PSK";
      };
    };
  };
}
