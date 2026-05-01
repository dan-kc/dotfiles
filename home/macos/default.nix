{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ 
    ./wezterm.nix
  ];
  home.username = "danielcox";
  home.homeDirectory = "/Users/danielcox";

  home.file = {
    "Library/Application\ Support/lazygit/config.yml".source = ../common/lazygit.yml;
    ".config/yabai/yabairc".source = ./yabairc;
    ".config/skhd/skhdrc".source = ./skhdrc;
    ".zprofile".source = ./zprofile;
    ".local/bin/pbcopy" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        if [[ -n "''${SSH_TTY:-}" ]]; then
          tty_path="/dev/tty"
          if [[ ! -w "$tty_path" ]]; then
            tty_path="$SSH_TTY"
          fi

          printf '\033]52;c;%s\a' "$(base64 | tr -d '\r\n')" > "$tty_path"
          exit 0
        fi

        exec /usr/bin/pbcopy "$@"
      '';
    };
  };

  home.packages = with pkgs; [
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

  nixpkgs.overlays = [
    (_final: prev: {
      # direnv 2.37.1 can hang in upstream shell tests during checkPhase on Darwin.
      direnv = prev.direnv.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];

  # Allow home-manager to manage home-manager.
  programs.home-manager.enable = true;
}
