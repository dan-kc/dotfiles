{
  description = "dots...";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:dan-kc/neovim";
    # flake-gen.url = "github:dan-kc/flake-gen";
    jt.url = "github:dan-kc/jt";
    nix-colors.url = "github:misterio77/nix-colors";
    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";
    yazi.url = "github:sxyazi/yazi";
    sops-nix.url = "github:Mic92/sops-nix";
    hyprland.url = "github:hyprwm/Hyprland";
    xremap-flake.url = "github:xremap/nix-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # hyprland.url = "github:hyprwm/Hyprland/refs/tags/v0.49.0"; <- worksish
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=0.48.1";
    # hy3.url = "github:outfoxxed/hy3?ref=hl0.49.0";
    # hy3.url = "github:outfoxxed/hy3";

    hy3.url = "github:outfoxxed/hy3";
    hy3.inputs.hyprland.follows = "hyprland";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
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
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixfmt-rfc-style
          nil
          lua-language-server
          stylua
          taplo
          sops
          age
          ssh-to-age
        ];
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
    };
}
