{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../agents
  ];

  nixpkgs.overlays = [
    (_final: _prev: {
    })
  ];

  home.packages =
    with pkgs;
    lib.optionals stdenv.hostPlatform.isLinux [
      (callPackage ../../pkgs/t3code-desktop { })
    ]
    ++ [
      lazydocker
      imagemagick
      sentry-cli
      qpdf
    ];
}
