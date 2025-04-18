{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.wireless.enable = lib.mkForce false;
  networking.hostName = "box";
}
