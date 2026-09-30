{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../common/pi.nix
  ];

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
