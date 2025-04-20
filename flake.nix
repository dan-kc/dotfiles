{
  description = "dots...";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    neovim.url = "github:dan-kc/neovim";
    wezterm.url = "github:wez/wezterm?dir=nix";
    yazi.url = "github:sxyazi/yazi";
    sops-nix.url = "github:Mic92/sops-nix";
    hyprland.url = "github:hyprwm/Hyprland";
    xremap-flake.url = "github:xremap/nix-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/805c8f56e8ebac1527176fc9d551f73c4cd886f6";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      # These are all flakes
      nixpkgs,
      nix-darwin,
      home-manager,
      self,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      # 'nixos-rebuild' looks here
      nixosConfigurations = {
        box = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/common.nix
            ./system/box
          ];
        };
        plank = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/common.nix
            ./system/plank
          ];
        };
      };

      # 'home-manager' looks here
      homeConfigurations = {
        daniel = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home
          ];
        };
      };

      # 'darwin-rebuild' looks here
      dawrinConfigurations = {
        air = nix-darwin.lib.darwinSystem {
          modules = [
            ./home/mac
          ];
        };
      };
      darwinPackages = self.darwinConfigurations."air".pkgs;
    };
}
