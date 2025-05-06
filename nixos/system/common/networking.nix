{ config, ... }:

{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8081 ];
      allowedUDPPorts = [ ];
      allowPing = false;
      # trustedInterfaces = [ ];
      checkReversePath = true;

      interfaces = {
        "wlp2s0" = {
          allowedTCPPorts = [
            8081
          ];
        };
      };
    };

    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wifi.path;
      networks = {
        "Redefined".pskRaw = "ext:COWORK_SPACE";
        "M-D-HOME".pskRaw = "ext:HOME";
      };
    };
  };
}
