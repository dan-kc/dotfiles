{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ];

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.system}".default;
    })
  ];
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

  home.packages = with pkgs; [
    claude-code
    lazygit
    neovim
    zoxide
  ];

  home.username = "danielcox";
  home.homeDirectory = "Users/danielcox";
  home.stateVersion = "24.05";

  # Allow home-manager to manage home-manager.
  programs.home-manager.enable = true;
}
