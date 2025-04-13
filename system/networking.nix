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
        "M-D-HOME".psk = "ext:HOME_PSK";
        "SP OFFICE 5G".psk = "ext:SP_OFFICE_PSK";
        "SP OFFICE 2G".psk = "ext:SP_OFFICE_PSK";
        "SP Upstairs WiFi".psk = "ext:SP_OFFICE_UPSTAIRS_PSK";
      };
    };
  };
}
