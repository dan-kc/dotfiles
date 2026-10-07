{
  ...
}:
{
  home.file = {
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
}
