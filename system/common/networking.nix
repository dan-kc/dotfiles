{ config, ... }:

{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowPing = false;
      # trustedInterfaces = [ ];
      checkReversePath = true;

      # allowedTCPPorts = [ 8081 ];
      # interfaces = {
      #   "wlp2s0" = {
      #     allowedTCPPorts = [
      #       8081
      #     ];
      #   };
      # };
    };

    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wifi.path;
      networks = {
        "Redefined".pskRaw = "ext:COWORK_SPACE";
        "M-D-HOME".pskRaw = "ext:HOME";
        "SP Office 5G".pskRaw = "ext:SP_OFFICE";
      };
    };
  };
}
