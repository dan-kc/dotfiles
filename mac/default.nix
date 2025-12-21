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

  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    claude-code
    lazygit
    neovim
    zoxide
  ];

  home.stateVersion = "24.05";
}
