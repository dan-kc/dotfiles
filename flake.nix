{
  description = "dots...";

  inputs = {
    # Flakes that will be evaluated when nix-rebuild switch is called.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    neovim.url = "./flakes/neovim";
    wezterm.url = "github:wez/wezterm?dir=nix";
  };

  outputs =
    {
      # These are all flakes
      nixpkgs,
      home-manager,
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
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./system ];
        };
      };

      # 'home-manager' looks here
      homeConfigurations = {
        daniel = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home ];
        };
      };
    };
}
