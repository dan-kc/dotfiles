{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../agents/pi
    # No T3 Code here, so keep native subagent delegation available.
    ../agents/pi/subagents.nix
    inputs.oh-my-pi.homeManagerModules.default
  ];

  programs.omp.enable = true;

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
    qpdf
  ];
}
