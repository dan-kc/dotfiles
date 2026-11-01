{
  inputs,
  lib,
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

  home.packages =
    with pkgs;
    lib.optionals stdenv.hostPlatform.isLinux [
      (callPackage ../../pkgs/t3code-desktop { })
      affine
    ]
    ++ [
      codex
      flake-gen
      lazydocker
      imagemagick
      sentry-cli
      qpdf
    ];
}
