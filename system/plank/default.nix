{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.xremap-flake.nixosModules.default
  ];
  services.xremap.config.modmap = [
    {
      name = "Global";
      remap = {
        "CapsLock" = "Esc";
      };
    }
  ];
  environment.systemPackages = with pkgs; [
    acpi
    powertop
  ];
  powerManagement.powertop.enable = true;
  networking.hostName = "plank";
}
