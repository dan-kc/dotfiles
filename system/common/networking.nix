{ config, ... }:

{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowPing = false;
      checkReversePath = true;
    };

    wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wifi.path;
      networks = {
        "Redefined".pskRaw = "ext:COWORK_SPACE";
        "M-D-HOME".pskRaw = "ext:HOME";
        "SP Office 5G".pskRaw = "ext:SP_OFFICE";
        "VodafoneMobileWiFi-586764".pskRaw = "ext:AIRBNB";
      };
    };
  };
}
