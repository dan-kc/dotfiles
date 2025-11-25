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
    inputs.tuxedo-nixos.nixosModules.default
  ];
  services.xremap.enable = true;
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

  boot = {
    # Motorcomm YT6801 LAN drivers
    extraModulePackages = with config.boot.kernelPackages; [ yt6801 ];
    kernelParams = [
      "acpi.ec_no_wakeup=1" # Fixes ACPI wakeup issues
      "amdgpu.dcdebugmask=0x10" # Fixes Wayland slowdowns/freezes
    ];
  };

  # Requires a system module from this flake:
  # https://github.com/sund3RRR/tuxedo-nixos?tab=readme-ov-file#option-2-nix-flake
  hardware = {
    tuxedo-drivers.enable = true;
    tuxedo-control-center.enable = true;
  };

  # Let TUXEDO Control Center handle CPU frequencies
  services.power-profiles-daemon.enable = false;
}
