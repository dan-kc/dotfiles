{
  pkgs,
  inputs,
  config,
  ...
}:
let
  hexToRGBString = inputs.nix-colors.lib-core.conversions.hexToRGBString;

  status-notify = pkgs.writeShellScriptBin "status-notify" ''
    battery=$(${pkgs.acpi}/bin/acpi -b | cut -d: -f2- | xargs)
    date=$(date +"%Y-%m-%d %H:%M:%S")
    ${pkgs.libnotify}/bin/notify-send "Battery: $battery" "Date: $date"
  '';

  term-cwd = pkgs.writeShellScriptBin "term-cwd" ''
    pid=$(niri msg --json focused-window | ${pkgs.jq}/bin/jq '.pid')
    if [ -n "$pid" ] && [ "$pid" != "null" ]; then
      ppid=$(${pkgs.procps}/bin/pgrep --newest --parent "$pid" 2>/dev/null)
      if [ -n "$ppid" ]; then
        dir=$(readlink /proc/"$ppid"/cwd 2>/dev/null || echo "$HOME")
      else
        dir="$HOME"
      fi
    else
      dir="$HOME"
    fi
    [ -d "$dir" ] || dir="$HOME"
    exec ${pkgs.alacritty}/bin/alacritty --working-directory "$dir"
  '';

  nvim-cwd = pkgs.writeShellScriptBin "nvim-cwd" ''
    pid=$(niri msg --json focused-window | ${pkgs.jq}/bin/jq '.pid')
    if [ -n "$pid" ] && [ "$pid" != "null" ]; then
      ppid=$(${pkgs.procps}/bin/pgrep --newest --parent "$pid" 2>/dev/null)
      if [ -n "$ppid" ]; then
        dir=$(readlink /proc/"$ppid"/cwd 2>/dev/null || echo "$HOME")
      else
        dir="$HOME"
      fi
    else
      dir="$HOME"
    fi
    [ -d "$dir" ] || dir="$HOME"
    exec ${pkgs.alacritty}/bin/alacritty --working-directory "$dir" -e zsh -c '${pkgs.neovim}/bin/nvim .; exec zsh'
  '';

  window-clone = pkgs.writeShellScriptBin "window-clone" ''
    window_info=$(niri msg --json focused-window)
    app_id=$(echo "$window_info" | ${pkgs.jq}/bin/jq -r '.app_id // empty')
    title=$(echo "$window_info" | ${pkgs.jq}/bin/jq -r '.title // empty')
    pid=$(echo "$window_info" | ${pkgs.jq}/bin/jq -r '.pid // empty')

    # Vivaldi window
    if [[ "$app_id" == vivaldi* ]] || [[ "$app_id" == Vivaldi* ]]; then
        HIST_FILE="$HOME/.config/vivaldi/Default/History"
        TMP_HIST="/tmp/vivaldi_hist_copy"
        cp "$HIST_FILE" "$TMP_HIST"
        # Strip " - Vivaldi" suffix from window title
        clean_title=$(echo "$title" | sed 's/ - Vivaldi$//')
        escaped_title=$(echo "$clean_title" | sed "s/'/'''/g")
        # Try exact match first, then partial match
        URL=$(${pkgs.sqlite}/bin/sqlite3 "$TMP_HIST" "SELECT url FROM urls WHERE title = '$escaped_title' ORDER BY last_visit_time DESC LIMIT 1;")
        if [ -z "$URL" ]; then
            URL=$(${pkgs.sqlite}/bin/sqlite3 "$TMP_HIST" "SELECT url FROM urls WHERE title LIKE '%$escaped_title%' ORDER BY last_visit_time DESC LIMIT 1;")
        fi
        rm -f "$TMP_HIST"
        if [ -n "$URL" ]; then
            vivaldi --new-window "$URL"
        else
            ${pkgs.libnotify}/bin/notify-send "Could not find URL for: $clean_title"
        fi
        exit 0
    fi

    # Alacritty window (terminal or neovim)
    if [[ "$app_id" == "Alacritty" ]] || [[ "$app_id" == "alacritty" ]]; then
        # Check if running neovim
        nvim_pid=$(${pkgs.procps}/bin/pgrep -P "$pid" -x nvim 2>/dev/null | head -1)
        if [ -z "$nvim_pid" ]; then
            for child in $(${pkgs.procps}/bin/pgrep -P "$pid" 2>/dev/null); do
                nvim_pid=$(${pkgs.procps}/bin/pgrep -P "$child" -x nvim 2>/dev/null | head -1)
                [ -n "$nvim_pid" ] && break
            done
        fi

        if [ -n "$nvim_pid" ]; then
            # Neovim - clone at same file/location
            socket=$(find /run/user/$(id -u)/ -maxdepth 1 -name "nvim.$nvim_pid.*" 2>/dev/null | head -1)
            if [ -z "$socket" ]; then
                for child_nvim in $(${pkgs.procps}/bin/pgrep -P "$nvim_pid" -x nvim 2>/dev/null); do
                    socket=$(find /run/user/$(id -u)/ -maxdepth 1 -name "nvim.$child_nvim.*" 2>/dev/null | head -1)
                    [ -n "$socket" ] && break
                done
            fi
            if [ -n "$socket" ]; then
                file=$(${pkgs.neovim}/bin/nvim --server "$socket" --remote-expr 'expand("%:p")' 2>/dev/null)
                line=$(${pkgs.neovim}/bin/nvim --server "$socket" --remote-expr 'line(".")' 2>/dev/null)
                col=$(${pkgs.neovim}/bin/nvim --server "$socket" --remote-expr 'col(".")' 2>/dev/null)
                cwd=$(readlink /proc/"$nvim_pid"/cwd 2>/dev/null || echo "$HOME")
                if [ -n "$file" ] && [ -f "$file" ]; then
                    exec ${pkgs.alacritty}/bin/alacritty --working-directory "$cwd" -e zsh -c "${pkgs.neovim}/bin/nvim \"+call cursor($line,$col)\" \"$file\"; exec zsh"
                else
                    ${pkgs.libnotify}/bin/notify-send "No file open in neovim"
                fi
            else
                ${pkgs.libnotify}/bin/notify-send "Could not find neovim socket"
            fi
        else
            # Regular terminal - open at CWD
            ppid=$(${pkgs.procps}/bin/pgrep --newest --parent "$pid" 2>/dev/null)
            if [ -n "$ppid" ]; then
                dir=$(readlink /proc/"$ppid"/cwd 2>/dev/null || echo "$HOME")
            else
                dir="$HOME"
            fi
            [ -d "$dir" ] || dir="$HOME"
            exec ${pkgs.alacritty}/bin/alacritty --working-directory "$dir"
        fi
        exit 0
    fi

    ${pkgs.libnotify}/bin/notify-send "Cannot duplicate: $app_id"
  '';

  nvim-tabs = pkgs.writeShellScriptBin "nvim-tabs" ''
    windows=$(niri msg --json windows)
    list=""

    # Loop through alacritty windows and check for nvim child processes
    while read -r line; do
        win_id=$(echo "$line" | ${pkgs.jq}/bin/jq -r '.id')
        win_pid=$(echo "$line" | ${pkgs.jq}/bin/jq -r '.pid')

        # Check if nvim is running in this terminal
        nvim_pid=$(${pkgs.procps}/bin/pgrep -P "$win_pid" -x nvim 2>/dev/null | head -1)
        if [ -z "$nvim_pid" ]; then
            for child in $(${pkgs.procps}/bin/pgrep -P "$win_pid" 2>/dev/null); do
                nvim_pid=$(${pkgs.procps}/bin/pgrep -P "$child" -x nvim 2>/dev/null | head -1)
                [ -n "$nvim_pid" ] && break
            done
        fi

        if [ -n "$nvim_pid" ]; then
            # Get the actual filename from neovim
            socket=$(find /run/user/$(id -u)/ -maxdepth 1 -name "nvim.$nvim_pid.*" 2>/dev/null | head -1)
            if [ -z "$socket" ]; then
                for child_nvim in $(${pkgs.procps}/bin/pgrep -P "$nvim_pid" -x nvim 2>/dev/null); do
                    socket=$(find /run/user/$(id -u)/ -maxdepth 1 -name "nvim.$child_nvim.*" 2>/dev/null | head -1)
                    [ -n "$socket" ] && break
                done
            fi
            if [ -n "$socket" ]; then
                file=$(${pkgs.neovim}/bin/nvim --server "$socket" --remote-expr 'expand("%:t")' 2>/dev/null)
                [ -z "$file" ] && file="[No file]"
            else
                file="[Unknown]"
            fi
            list="$list$file | $win_id"$'\n'
        fi
    done < <(echo "$windows" | ${pkgs.jq}/bin/jq -c '.[] | select(.app_id == "Alacritty" or .app_id == "alacritty")')

    CHOICE=$(echo -n "$list" | ${pkgs.fuzzel}/bin/fuzzel --dmenu -l 20 -p "Neovim windows: ")

    WINDOW_ID=$(echo "$CHOICE" | ${pkgs.gawk}/bin/awk -F ' \\| ' '{print $NF}')

    if [ -n "$WINDOW_ID" ]; then
        niri msg action focus-window --id "$WINDOW_ID"
    fi
  '';

  vivaldi-tabs = pkgs.writeShellScriptBin "vivaldi-tabs" ''
    windows=$(niri msg --json windows)

    CHOICE=$(echo "$windows" | ${pkgs.jq}/bin/jq -r '.[] | select(.app_id == "vivaldi-stable" or .app_id == "vivaldi" or .app_id == "Vivaldi") | "\(.title) | \(.id)"' | \
        ${pkgs.fuzzel}/bin/fuzzel --dmenu -l 20 -p "Vivaldi windows: ")

    WINDOW_ID=$(echo "$CHOICE" | ${pkgs.gawk}/bin/awk -F ' \\| ' '{print $NF}')

    if [ -n "$WINDOW_ID" ]; then
        niri msg action focus-window --id "$WINDOW_ID"
    fi
  '';

  vivaldi-history = pkgs.writeShellScriptBin "vivaldi-history" ''
    HIST_FILE="$HOME/.config/vivaldi/Default/History"
    TMP_HIST="/tmp/vivaldi_hist_copy"

    cp "$HIST_FILE" "$TMP_HIST"

    CHOICE=$(${pkgs.sqlite}/bin/sqlite3 "$TMP_HIST" \
        "SELECT title || ' | ' || url FROM urls ORDER BY last_visit_time DESC LIMIT 500;" | \
        ${pkgs.fuzzel}/bin/fuzzel --dmenu -l 20 -p "Search History: ")

    URL=$(echo "$CHOICE" | ${pkgs.gawk}/bin/awk -F ' \\| ' '{print $NF}')

    if [ -n "$URL" ]; then
        vivaldi --new-window "$URL"
    fi

    rm -f "$TMP_HIST"
  '';

  aichat-new = pkgs.writeShellScriptBin "aichat-new" ''
    exec ${pkgs.alacritty}/bin/alacritty -e zsh -c '${pkgs.aichat}/bin/aichat; exec zsh'
  '';

  tv-notes = pkgs.writeShellScriptBin "tv-notes" ''
    exec ${pkgs.alacritty}/bin/alacritty --working-directory ~/notes -e zsh -c 'selected=$(tv); if [ -n "$selected" ]; then ${pkgs.neovim}/bin/nvim "$selected"; fi; exec zsh'
  '';

  nvim-clone = pkgs.writeShellScriptBin "nvim-clone" ''
    window_info=$(niri msg --json focused-window)
    app_id=$(echo "$window_info" | ${pkgs.jq}/bin/jq -r '.app_id // empty')
    pid=$(echo "$window_info" | ${pkgs.jq}/bin/jq -r '.pid // empty')

    if [ "$app_id" != "Alacritty" ] && [ "$app_id" != "alacritty" ]; then
      ${pkgs.libnotify}/bin/notify-send "Not in neovim window"
      exit 0
    fi

    # Find neovim child process
    nvim_pid=$(${pkgs.procps}/bin/pgrep -P "$pid" -x nvim 2>/dev/null | head -1)
    if [ -z "$nvim_pid" ]; then
      # Try looking deeper (nvim might be grandchild via shell)
      for child in $(${pkgs.procps}/bin/pgrep -P "$pid" 2>/dev/null); do
        nvim_pid=$(${pkgs.procps}/bin/pgrep -P "$child" -x nvim 2>/dev/null | head -1)
        [ -n "$nvim_pid" ] && break
      done
    fi

    if [ -z "$nvim_pid" ]; then
      ${pkgs.libnotify}/bin/notify-send "Not in neovim window"
      exit 0
    fi

    # Find neovim server socket (check main nvim and its child processes)
    socket=$(find /run/user/$(id -u)/ -maxdepth 1 -name "nvim.$nvim_pid.*" 2>/dev/null | head -1)
    if [ -z "$socket" ]; then
      # Check child nvim processes (embedded nvim shares buffer state)
      for child_nvim in $(${pkgs.procps}/bin/pgrep -P "$nvim_pid" -x nvim 2>/dev/null); do
        socket=$(find /run/user/$(id -u)/ -maxdepth 1 -name "nvim.$child_nvim.*" 2>/dev/null | head -1)
        [ -n "$socket" ] && break
      done
    fi
    if [ -z "$socket" ]; then
      ${pkgs.libnotify}/bin/notify-send "Could not find neovim socket"
      exit 1
    fi

    # Get current file and cursor position
    file=$(${pkgs.neovim}/bin/nvim --server "$socket" --remote-expr 'expand("%:p")' 2>/dev/null)
    line=$(${pkgs.neovim}/bin/nvim --server "$socket" --remote-expr 'line(".")' 2>/dev/null)
    col=$(${pkgs.neovim}/bin/nvim --server "$socket" --remote-expr 'col(".")' 2>/dev/null)
    cwd=$(readlink /proc/"$nvim_pid"/cwd 2>/dev/null || echo "$HOME")

    if [ -z "$file" ] || [ ! -f "$file" ]; then
      ${pkgs.libnotify}/bin/notify-send "No file open in neovim"
      exit 1
    fi

    # Spawn new alacritty with neovim at same location
    exec ${pkgs.alacritty}/bin/alacritty --working-directory "$cwd" -e zsh -c "${pkgs.neovim}/bin/nvim \"+call cursor($line,$col)\" \"$file\"; exec zsh"
  '';

  niri-scripts = pkgs.symlinkJoin {
    name = "niri-scripts";
    paths = [ status-notify term-cwd nvim-cwd nvim-clone vivaldi-history vivaldi-tabs nvim-tabs window-clone aichat-new tv-notes ];
  };
in
{
  home.packages = [ niri-scripts ];

  home.file = {
    ".config/niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us,gb"
            }
            repeat-rate 25
            repeat-delay 150
        }

        touchpad {
            tap
            natural-scroll
            scroll-factor 0.3
        }

        mouse {
            accel-profile "flat" // off
            accel-speed -0.3
            natural-scroll
        }
    }

    prefer-no-csd
    layout {
        gaps 16
        center-focused-column "never"
        
        preset-column-widths {
            proportion 0.5
            proportion 1.0
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 4
            active-color "#${config.colorScheme.palette.base0C}"
            inactive-color "#${config.colorScheme.palette.base0C}"
            urgent-color "#${config.colorScheme.palette.base09}"
        }

        background-color "transparent"

        border {
            off
        }

        shadow {
            off
        }
    }

    overview {
        zoom 0.3
        backdrop-color "#${config.colorScheme.palette.base00}"
        workspace-shadow {
            off
        }
    }

    // Named workspaces
    workspace "zero"
    workspace "one"
    workspace "two"
    workspace "three"
    workspace "four"
    workspace "five"
    workspace "six"
    workspace "seven"
    workspace "eight"
    workspace "nine"

    spawn-at-startup "udiskie"
    spawn-at-startup "mako"

    // Environment variables
    environment {
        NIXOS_OZONE_WL "1"
    }

    binds {
        // Basics
        Mod+Space repeat=false { spawn "launcher"; }
        Mod+Q { close-window; }
        Mod+O repeat=false { toggle-overview; }
        
        // Applications
        Mod+Y repeat=false { spawn-sh "alacritty --working-directory ~/ --command zsh -c 'yazi; exec zsh'"; }
        Mod+T repeat=false hotkey-overlay-title="Spawn terminal" { spawn "term-cwd"; }
        Mod+E repeat=false hotkey-overlay-title="Spawn neovim" { spawn "nvim-cwd"; }
        Mod+B repeat=false hotkey-overlay-title="Spawn neovim" { spawn "vivaldi" "--new-window"; }

        // Notes/Utilities
        Mod+J repeat=false { spawn-sh "alacritty --working-directory ~/notes --command zsh -c 'nvim $(jt); exec zsh'"; }

        Super+Ctrl+L { spawn "swaylock"; }
        // AI Chat
        Mod+A repeat=false hotkey-overlay-title="Open aichat" { spawn "aichat-new"; }

        Mod+U { spawn "status-notify"; }

        Mod+H repeat=false hotkey-overlay-title="Search Vivaldi history" { spawn "vivaldi-history"; }
        Mod+Ctrl+B repeat=false hotkey-overlay-title="Switch Neovim window" { spawn "nvim-tabs"; }
        Mod+D repeat=false hotkey-overlay-title="Duplicate window" { spawn "window-clone"; }

        Mod+Ctrl+T repeat=false hotkey-overlay-title="Switch Vivaldi window" { spawn "vivaldi-tabs"; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-workspace-down; }
        Mod+Up    { focus-workspace-up; }
        Mod+Right { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-column-to-workspace-down; }
        Mod+Ctrl+Up    { move-column-to-workspace-up; }
        Mod+Ctrl+Right { move-column-right; }

        // Named workspaces
        Mod+0 { focus-workspace "zero"; }
        Mod+1 { focus-workspace "one"; }
        Mod+2 { focus-workspace "two"; }
        Mod+3 { focus-workspace "three"; }
        Mod+4 { focus-workspace "four"; }
        Mod+5 { focus-workspace "five"; }
        Mod+6 { focus-workspace "six"; }
        Mod+7 { focus-workspace "seven"; }
        Mod+8 { focus-workspace "eight"; }
        Mod+9 { focus-workspace "nine"; }

        Mod+Ctrl+0 { move-column-to-workspace "zero"; }
        Mod+Ctrl+1 { move-column-to-workspace "one"; }
        Mod+Ctrl+2 { move-column-to-workspace "two"; }
        Mod+Ctrl+3 { move-column-to-workspace "three"; }
        Mod+Ctrl+4 { move-column-to-workspace "four"; }
        Mod+Ctrl+5 { move-column-to-workspace "five"; }
        Mod+Ctrl+6 { move-column-to-workspace "six"; }
        Mod+Ctrl+7 { move-column-to-workspace "seven"; }
        Mod+Ctrl+8 { move-column-to-workspace "eight"; }
        Mod+Ctrl+9 { move-column-to-workspace "nine"; }

        Mod+R { switch-preset-column-width; }
        // Mod+F { maximize-column; }

        // Toggle tabbed column display mode.
        // Windows in this column will appear as vertical tabs,
        // rather than stacked on top of each other.
        // Mod+W { toggle-column-tabbed-display; }

        Print { screenshot; }

        // Audio
        XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
        XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

        // Brighness
        XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }


        // Example media keys mapping using playerctl.
        // This will work with any MPRIS-enabled media player.
        XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
        XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
        XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }

        // Screenshot (doesn't work yet?)
        // screenshot-path "~/screenshots/%Y-%m-%d %H-%M-%S.png"
        
        // Applications such as remote-desktop clients and software KVM switches may
        // request that niri stops processing the keyboard shortcuts defined here
        // so they may, for example, forward the key presses as-is to a remote machine.
        // It's a good idea to bind an escape hatch to toggle the inhibitor,
        // so a buggy application can't hold your session hostage.
        //
        // The allow-inhibiting=false property can be applied to other binds as well,
        // which ensures niri always processes them, even when an inhibitor is active.
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        // The quit action will show a confirmation dialog to avoid accidental exits.
        Mod+Ctrl+Q { quit; }
    }
    '';
  };
}
