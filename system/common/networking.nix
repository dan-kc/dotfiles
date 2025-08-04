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

    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          # Generate a private key file with:
          # sudo mkdir -p /etc/wireguard/
          # sudo sh -c 'umask 077; wg genkey | tee /etc/wireguard/wg0-client-private.key | wg pubkey > /etc/wireguard/wg0-client-public.key'
          privateKeyFile = "/etc/wireguard/wg0-client-private.key";

          # Client's internal VPN IP address.
          # This must match the allowedIPs for this peer on the server.

          # ips = [ "10.0.0.2/32" ]; on your client sets the client's internal VPN IP to 10.0.0.2 and indicates that only this specific IP address is assigned to its wg0 interface. The client doesn't need to know the entire subnet itself because it relies on the AllowedIPs in its peer configuration to tell it what traffic to send to the server.
          ips = [ "10.0.0.2/32" ];

          peers = [
            {
              #   # The public key of your WireGuard server (the EC2 instance)
              publicKey = "eNd8RkOv5T34XUdAI9p7yup1smxHEfriQQsZGXviL00=";
              endpoint = "18.130.122.49:51820"; # Public IP of VPN
              #   # Which IPs to route through the VPN.
              #   # For your use case, only the Target EC2's private IP
              allowedIPs = [
                "10.0.1.4/32"
              ];
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };
}
