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
    # Uncomment to pin kernel if wifi breaks after nixpkgs update
    # kernelPackages = pkgs.linuxPackages_6_12;

    kernelPackages = pkgs.linuxPackages.extend (_final: prev: {
      yt6801 = prev.yt6801.overrideAttrs (old: {
        # Include module signing flags and let NixOS generate module indexes.
        makeFlags = prev.kernelModuleMakeFlags ++ (old.makeFlags or [ ]);
      });
      tuxedo-drivers = prev.tuxedo-drivers.overrideAttrs (old: {
        # Let recursive make inherit flags; expanding MAKEFLAGS in the shell
        # breaks the kernel module signing command's quoting.
        postPatch = (old.postPatch or "") + ''
          substituteInPlace Makefile \
            --replace-fail 'make -C' '$(MAKE) -C' \
            --replace-fail ' $(MAKEFLAGS)' ""
        '';
      });
    });

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
