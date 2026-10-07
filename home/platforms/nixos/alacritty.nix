{
  pkgs,
  config,
  ...
}:
let
  alacritty-font-size = pkgs.writeShellScriptBin "alacritty-font-size" ''
    set -eu

    size="''${1:-}"
    case "$size" in
      ""|*[!0-9.]*)
        exit 2
        ;;
    esac

    find_alacritty_env() {
      root_pid="$1"
      queue="$(${pkgs.procps}/bin/pgrep -P "$root_pid" 2>/dev/null || true)"

      while [ -n "$queue" ]; do
        next_queue=""

        for candidate in $queue; do
          [ "$candidate" = "$$" ] && continue

          env_file="/proc/$candidate/environ"
          if [ -r "$env_file" ]; then
            env_dump="$(${pkgs.coreutils}/bin/tr '\0' '\n' < "$env_file" 2>/dev/null || true)"
            socket="$(printf '%s\n' "$env_dump" | ${pkgs.gnused}/bin/sed -n 's/^ALACRITTY_SOCKET=//p' | ${pkgs.coreutils}/bin/head -n 1)"
            window_id="$(printf '%s\n' "$env_dump" | ${pkgs.gnused}/bin/sed -n 's/^ALACRITTY_WINDOW_ID=//p' | ${pkgs.coreutils}/bin/head -n 1)"

            if [ -n "$socket" ] && [ -S "$socket" ] && [ -n "$window_id" ]; then
              printf '%s\n%s\n' "$socket" "$window_id"
              return 0
            fi
          fi

          children="$(${pkgs.procps}/bin/pgrep -P "$candidate" 2>/dev/null || true)"
          if [ -n "$children" ]; then
            next_queue="$next_queue $children"
          fi
        done

        queue="$next_queue"
      done

      return 1
    }

    focused_window="$(${pkgs.niri}/bin/niri msg --json focused-window 2>/dev/null || true)"
    focused_pid="$(printf '%s\n' "$focused_window" | ${pkgs.jq}/bin/jq -r 'select(((.app_id // "") | ascii_downcase) == "alacritty") | .pid // empty' 2>/dev/null || true)"

    if [ -n "$focused_pid" ]; then
      target="$(find_alacritty_env "$focused_pid" || true)"
      if [ -n "$target" ]; then
        socket="$(printf '%s\n' "$target" | ${pkgs.gnused}/bin/sed -n '1p')"
        window_id="$(printf '%s\n' "$target" | ${pkgs.gnused}/bin/sed -n '2p')"
        exec ${pkgs.alacritty}/bin/alacritty msg --socket "$socket" config --window-id "$window_id" "font.size=$size"
      fi

      exit 1
    fi

    if [ -n "''${ALACRITTY_SOCKET:-}" ] && [ -n "''${ALACRITTY_WINDOW_ID:-}" ]; then
      exec ${pkgs.alacritty}/bin/alacritty msg --socket "$ALACRITTY_SOCKET" config --window-id "$ALACRITTY_WINDOW_ID" "font.size=$size"
    fi

    exec ${pkgs.alacritty}/bin/alacritty msg config "font.size=$size"
  '';
in
{
  home.file = {
    ".config/alacritty.toml".text = ''
      [env]
      TERM = "xterm-256color"

      [terminal]
      osc52 = "OnlyCopy"

      [colors]
      draw_bold_text_with_bright_colors = false

      # Default colors
      [colors.primary]
      background = '#${config.colorScheme.palette.base00}'
      foreground = '#${config.colorScheme.palette.base05}'

      # Colors the cursor will use if `custom_cursor_colors` is true
      [colors.cursor]
      text = '#${config.colorScheme.palette.base00}'
      cursor = '#${config.colorScheme.palette.base05}'

      # Normal colors
      [colors.normal]
      black = '#${config.colorScheme.palette.base00}'
      red = '#${config.colorScheme.palette.base08}'
      green = '#${config.colorScheme.palette.base0B}'
      yellow = '#${config.colorScheme.palette.base0A}'
      blue = '#${config.colorScheme.palette.base0D}'
      magenta = '#${config.colorScheme.palette.base0E}'
      cyan = '#${config.colorScheme.palette.base0C}'
      white = '#${config.colorScheme.palette.base05}'

      # Bright colors
      [colors.bright]
      black = '#${config.colorScheme.palette.base03}'
      red = '#${config.colorScheme.palette.base09}'
      green = '#${config.colorScheme.palette.base01}'
      yellow = '#${config.colorScheme.palette.base02}'
      blue = '#${config.colorScheme.palette.base04}'
      magenta = '#${config.colorScheme.palette.base06}'
      cyan = '#${config.colorScheme.palette.base0F}'
      white = '#${config.colorScheme.palette.base07}'

      [font]
      normal = { family = "${config.globalFonts.selectedFont}" } 
      builtin_box_drawing = false
      size = 9

      [scrolling]
      multiplier = 1

      [window]
      padding = { x = 20, y = 20 }
      dynamic_padding = true
      decorations = "None"
      opacity = 1.0

      [selection]
      save_to_clipboard = true

      [keyboard]
      bindings = [
        { key = "0", mods = "Control", command = { program = "${alacritty-font-size}/bin/alacritty-font-size", args = ["9"] } },
        { key = "1", mods = "Control", command = { program = "${alacritty-font-size}/bin/alacritty-font-size", args = ["19"] } },
        { key = "Plus", mods = "Control|Shift", action = "IncreaseFontSize" } # QMK inputs "Control|Shift Equals" when you try to "Control Plus". For some reason this fixes it.
      ]
    '';

  };
  home.packages = [
    pkgs.alacritty
    alacritty-font-size
  ];
}
