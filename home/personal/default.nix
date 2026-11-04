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

  nixpkgs.config.allowUnfreePackages = [ "claude-code" ];
  programs.claude-code.enable = true;

  nixpkgs.overlays = [
    (_final: _prev: {
      flake-gen = inputs.flake-gen.packages."${pkgs.stdenv.hostPlatform.system}".default;
    })
  ];

  home.packages =
    with pkgs;
    lib.optionals stdenv.hostPlatform.isLinux [
      (callPackage ../../pkgs/t3code-desktop { })
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
