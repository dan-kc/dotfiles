{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../common/pi.nix
    inputs.oh-my-pi.homeManagerModules.default
  ];

  programs.omp.enable = true;

  nixpkgs.overlays = [
    (_final: _prev: {
      flake-gen = inputs.flake-gen.packages."${pkgs.stdenv.hostPlatform.system}".default;
    })
  ];

  home.packages = with pkgs; [
    codex
    flake-gen
    lazydocker
    imagemagick
    qpdf
  ];
}
