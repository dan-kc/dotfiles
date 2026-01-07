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

  niri-scripts = pkgs.symlinkJoin {
    name = "niri-scripts";
    paths = [ status-notify term-cwd ];
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

    layout {
        gaps 16 // matches gaps_out
        center-focused-column "never"
        
        preset-column-widths {
            proportion 0.5
            proportion 1.0
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color "#${config.colorScheme.palette.base0C}"
            inactive-color "#${config.colorScheme.palette.base00}"
        }

        border {
            off
        }

        shadow {
            off
        }
    }

    spawn-at-startup "udiskie"
    spawn-at-startup "mako"

    // Environment variables
    environment {
        NIXOS_OZONE_WL "1"
    }

    binds {
        // Basics
        Mod+K repeat=false hotkey-overlay-title="Open hotkey overlay" { show-hotkey-overlay; }
        Mod+Space repeat=false hotkey-overlay-title="Spawn launcher" { spawn "launcher"; }
        Mod+Q hotkey-overlay-title="Close window" { close-window; }
        Super+Ctrl+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }
        Mod+O repeat=false { toggle-overview; }
        
        // Custom Terminal Binds (Notes/Utilities)
        Mod+J repeat=false { spawn-sh "alacritty --working-directory ~/notes --class floating --command zsh -c 'nvim $(jt)'"; }
        Mod+L repeat=false { spawn-sh "alacritty --working-directory ~/notes --class floating --command zsh -c 'nvim ~/notes/Todo.md'"; }
        Mod+S repeat=false { spawn-sh "alacritty --working-directory ~/notes --class floating --command zsh -c 'nvim ~/notes/Scratchpad.md'"; }
        Mod+Y repeat=false { spawn-sh "alacritty --working-directory ~/ --class floating --command yazi"; }
        Mod+T repeat=false { spawn "term-cwd"; }
        Mod+U { spawn "status-notify"; }
        // Clipboard
        Mod+C { spawn-sh "wl-paste | CLIPBOARD_NOGUI=1 cb copy"; }
        Mod+V { spawn-sh "CLIPBOARD_NOGUI=1 cb history | jq -r '.[].content | select(. != null)' | bemenu | wl-copy"; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-workspace-down; }
        Mod+Up    { focus-workspace-up; }
        Mod+Right { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-column-to-workspace-down; }
        Mod+Ctrl+Up    { move-column-to-workspace-up; }
        Mod+Ctrl+Right { move-column-right; }

        Mod+R { switch-preset-column-width; }
        // Mod+F { maximize-column; }

        // Toggle tabbed column display mode.
        // Windows in this column will appear as vertical tabs,
        // rather than stacked on top of each other.
        Mod+W { toggle-column-tabbed-display; }

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
        Mod+E { quit; }
    }
    '';
  };
}
