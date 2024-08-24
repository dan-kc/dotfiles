{...}:

{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
      allowPing = false;
      trustedInterfaces = [ ];
      checkReversePath = true;
    };

# Doesn't work, should try new router
   # wireless = {
   #   enable = true;
     ## networks = {
   #     "WIFI_NAME" = {
   #       psk = "PASSWORD";
   #     };
#      };
#    };
    interfaces = {
#      wlp3s0.useDHCP = true;
      eth0.useDHCP = true;
    };
  };
}
