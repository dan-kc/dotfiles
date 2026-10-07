{
  description = "dots...";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";

    neovim = {
      url = "github:dan-kc/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-gen.url = "github:dan-kc/flake-gen";
    jt.url = "github:dan-kc/jt";
    oh-my-pi = {
      url = "github:can1357/oh-my-pi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";
    xremap-flake.url = "github:xremap/nix-flake";

    nix-colors.url = "github:misterio77/nix-colors";

    yazi-base16 = {
      url = "github:matt-dong-123/base16.yazi";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      self,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      mkDevShell =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            nixfmt
            nil
            lua-language-server
            stylua
            taplo
            sops
            age
            ssh-to-age
          ];
        };
      mkHome =
        {
          system,
          username,
          modules,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
          };
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            {
              home = {
                inherit username;
                homeDirectory = "${
                  if nixpkgs.lib.hasSuffix "-darwin" system then "/Users" else "/home"
                }/${username}";
              };
            }
          ]
          ++ modules;
        };
    in
    {
      devShells = {
        x86_64-linux.default = mkDevShell "x86_64-linux";
        aarch64-darwin.default = mkDevShell "aarch64-darwin";
      };
      nixosConfigurations = {
        box = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/common
            ./system/box
          ];
        };
        plank = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/common
            ./system/plank
          ];
        };
      };

      homeConfigurations = {
        daniel = mkHome {
          inherit system;
          username = "daniel";
          modules = [
            ./home/base
            ./home/personal
            ./home/platforms/nixos
          ];
        };
        danielcox = mkHome {
          system = "aarch64-darwin";
          username = "danielcox";
          modules = [
            ./home/base
            ./home/personal
            ./home/platforms/darwin
            ./home/platforms/darwin/ssh-clipboard.nix
          ];
        };
        "daniel.cox" = mkHome {
          system = "aarch64-darwin";
          username = "daniel.cox";
          modules = [
            ./home/base
            ./home/platforms/darwin
            ./home/work
          ];
        };
      };
    };
}
