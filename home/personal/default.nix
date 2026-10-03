{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../agents/pi
  ];

  nixpkgs.overlays = [
    (_final: _prev: {
      flake-gen = inputs.flake-gen.packages."${pkgs.stdenv.hostPlatform.system}".default;
    })
  ];

  home.packages = with pkgs; [
    (callPackage ../../pkgs/t3code-desktop { })
    codex
    flake-gen
    lazydocker
    imagemagick
    sentry-cli
    qpdf
  ];
}
