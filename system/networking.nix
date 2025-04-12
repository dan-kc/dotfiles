{ ... }:

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
      networks = {
        "M-D-HOME".psk = "secret";
        # "PowerStudios".psk = "secret";
        "Redefined".psk = "secret";
        "SP OFFICE 5G".psk = "secret";
        "SP OFFICE 2G".psk = "secret";
        "SP Upstairs WiFi".psk = "50088690";
      };
    };
  };
}
