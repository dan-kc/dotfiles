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

        clipboard_file="''${XDG_CACHE_HOME:-$HOME/.cache}/ssh-pbcopy"

        if [[ -n "''${SSH_TTY:-}" ]]; then
          mkdir -p "$(dirname "$clipboard_file")"

          if (($# > 0)); then
            encoded="$(cat "$@" | tee "$clipboard_file" | base64 | tr -d '\r\n')"
          else
            encoded="$(tee "$clipboard_file" | base64 | tr -d '\r\n')"
          fi

          printf '\033]52;c;%s\a' "$encoded" > "$SSH_TTY"
          exit 0
        fi

        exec /usr/bin/pbcopy "$@"
      '';
    };
    ".local/bin/pbpaste" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        clipboard_file="''${XDG_CACHE_HOME:-$HOME/.cache}/ssh-pbcopy"

        if [[ -n "''${SSH_TTY:-}" ]]; then
          if [[ -f "$clipboard_file" ]]; then
            cat "$clipboard_file"
          fi
          exit 0
        fi

        exec /usr/bin/pbpaste "$@"
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
