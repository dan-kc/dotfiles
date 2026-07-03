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
        /*
          If you currently do not have internet access and you are trying to
          rebuild your config with no success due to being unable to reach
          https://cache.nixos.org, then run 'sudo nixos-rebuild switch --flake .
          --option substitute false'. This will build from local/source.
        */
        /*
          To access the portal page, hit a http (not https) site from your
          browser
        */
        "#StarbucksWifi" = { };
      };
    };
  };
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--accept-dns=false" ];
  };
}
