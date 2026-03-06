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
        "BTB-W26CHT".pskRaw = "ext:BTB-W26CHT";
        # "iPhone rass".psk = "ztz785i0frev";
        "119/32_5G".psk = "@NOSBAAN.h3j";
        ".@ TrueDigitalPark Free WiFi" = {};
        "AtlasWorkspace - Guest" = {};
      };
    };
  };
}
