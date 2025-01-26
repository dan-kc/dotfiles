{ ... }:

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

    interfaces = {
      eth0.useDHCP = true;
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
  };
}
