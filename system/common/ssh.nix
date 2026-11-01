{ lib, ... }:

{
  services = {
    openssh = {
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      enable = lib.mkDefault false;
    };
  };
}
