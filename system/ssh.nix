{...}:

{
  services = {
    openssh = {
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      enable = false;
    };
  };
}
