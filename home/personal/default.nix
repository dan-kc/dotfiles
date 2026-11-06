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
  # Nix's system-only CA default omits macOS's built-in public roots.
  programs.claude-code.package =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.symlinkJoin {
        name = "claude-code-macos";
        paths = [ pkgs.claude-code ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/claude \
            --set-default CLAUDE_CODE_CERT_STORE bundled,system
        '';
      }
    else
      pkgs.claude-code;

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
