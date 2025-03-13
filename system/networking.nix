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

    extraHosts = ''
      178.79.159.14 portal
      139.162.206.231 terra
    '';

    interfaces = {
      eth0.useDHCP = true;
      wlan0.useDHCP = true;
    };

    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.2.0.2/32" ];
        dns = [ "10.2.0.1" ];
        privateKeyFile = "/root/wg/private.key";
        peers = [
          {
            publicKey = "zctOjv4DH2gzXtLQy86Tp0vnT+PNpMsxecd2vUX/i0U=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "146.70.179.50:51820";
          }
        ];
      };
    };

    wireless = {
      enable = true;
      # wpa_supplicant.enable = true;
      # interfaces = [ "wlp3s0" ];
      interfaces = [ "wlan0" ];
      networks = {
        "M-D-HOME".psk = "secret";
        # "PowerStudios".psk = "secret";
      };
    };
  };
}
