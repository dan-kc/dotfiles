{
  pkgs,
  inputs,
  config,
  ...
}:
let
  hexToRGBString = inputs.nix-colors.lib-core.conversions.hexToRGBString;
in
{
  home.file = {
    ".config/hypr/hyprpaper.conf".text = '''';
  };

  home.packages = with pkgs; [
    wireplumber
    hyprpaper
    hyprshot
    hyprsunset
    jq
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # plugins = [ inputs.hy3.packages.x86_64-linux.hy3 ];
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    extraConfig = ''
      plugin = ${inputs.hy3.packages.x86_64-linux.hy3}/lib/libhy3.so
      monitor = HDMI-A-1, 2560x1440@60, auto, auto, mirror, eDP-1
      monitor = ,highrr,auto,auto

      $terminal = alacritty
      $browser = zen-twilight -P default
      $menu = bemenu-run

      exec-once = udiskie
      exec-once = mako
      exec-once = hyprpaper & sleep 0.5 && theme-switch
      exec-once = hyprsunset

      # for sceensharing: https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580
      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      # env = XCURSOR_SIZE,36
      env = HYPRCURSOR_SIZE,24

      general {
          gaps_in = 4
          gaps_out = 8
          border_size = 0

          # Disable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = hy3
      }

      decoration {
          shadow {
              enabled = false
          }
          rounding = 0
          active_opacity = 1.0
          inactive_opacity = 0.80
          blur {
              enabled = false
          }
      }

      animations {
          enabled = true
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 2, myBezier
          animation = windowsOut, 1, 2, default, popin 80%
          animation = border, 1, 2, default
          animation = borderangle, 1, 2, default
          animation = fade, 1, 2, default
          animation = workspaces, 1, 2, default
      }

      master {
          new_status = master
      }

      misc {
          force_default_wallpaper = 0
          disable_hyprland_logo = true
      }
      # 0 - Cursor movement will not change focus.
      # 1 - Cursor movement will always change focus to the window under the cursor.
      # 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
      # 3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
      input {
          repeat_rate = 25
          repeat_delay = 150
          follow_mouse = 1
          natural_scroll = true
          scroll_factor = 0.3
          kb_layout = us,gb
      }

      device {
          name = bastard-keyboards-charybdis-nano-(3x5)-splinky-mouse
          sensitivity = -0.9
      }
      device {
          name = bastard-keyboards-charybdis-(4x6)-splinky-mouse
          sensitivity = -0.9
      }

      $mainMod = WIN # Sets "Windows" key as main modifier
      $paste = CLIPBOARD_NOGUI=1 cb history | cat | jq -r '.[].content | select(. != null)' | bemenu | wl-copy
      $copy = wl-paste | CLIPBOARD_NOGUI=1 cb copy
      $screenshot = grim -g '$(slurp)'

      bind = $mainMod, J, exec, alacritty --working-directory ~/notes --class floating --command zsh -c "nvim $(jt)"
      bind = $mainMod, L, exec, alacritty --working-directory ~/notes --class floating --command zsh -c "nvim ~/notes/Todo.md"
      bind = $mainMod, S, exec, alacritty --working-directory ~/notes --class floating --command zsh -c "nvim ~/notes/Scratchpad.md"
      bind = $mainMod, Y, exec, alacritty --working-directory ~/ --class floating --command yazi
      bind = $mainMod, T, exec, alacritty --working-directory "$(pid=$(hyprctl activewindow -j | jq '.pid'); ppid=$(pgrep --newest --parent "$pid"); dir=$(readlink /proc/"$ppid"/cwd || echo "$HOME"); [ -d "$dir" ] && echo "$dir" || echo "$HOME")"
      bind = $mainMod, F, exec, alacritty -e bash -c 'selected_dir=$(zoxide query -l | fzf --preview "ls {}"); if [ -n "$selected_dir" ]; then cd "$selected_dir"; fi; exec zsh'

      env = HYPRCURSOR_THEME,rose-pine-hyprcursor

      # Screenshot a monitor
      bind = , PRINT, exec, hyprshot -m output
      # Screenshot a window
      bind = $mainMod, PRINT, exec, hyprshot -m window
      # Screenshot a region
      bind = $mainMod+SHIFT, PRINT, exec, hyprshot -m region

      bind = $mainMod, SPACE, exec, launcher
      bind = $mainMod, Q, killactive,
      bind = $mainMod, C, exec, $copy
      bind = $mainMod, V, exec, $paste

      # Switch workspaces with mainMod + [1-9]
      bind = $mainMod, 0, workspace, 1
      bind = $mainMod, 1, workspace, 2
      bind = $mainMod, 2, workspace, 3
      bind = $mainMod, 3, workspace, 4
      bind = $mainMod, 4, workspace, 5
      bind = $mainMod, 5, workspace, 6
      bind = $mainMod, 6, workspace, 7
      bind = $mainMod, 7, workspace, 8
      bind = $mainMod, 8, workspace, 9
      bind = $mainMod, 9, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod+SHIFT, 0, movetoworkspacesilent, 1
      bind = $mainMod+SHIFT, 1, movetoworkspacesilent, 2
      bind = $mainMod+SHIFT, 2, movetoworkspacesilent, 3
      bind = $mainMod+SHIFT, 3, movetoworkspacesilent, 4
      bind = $mainMod+SHIFT, 4, movetoworkspacesilent, 5
      bind = $mainMod+SHIFT, 5, movetoworkspacesilent, 6
      bind = $mainMod+SHIFT, 6, movetoworkspacesilent, 7
      bind = $mainMod+SHIFT, 7, movetoworkspacesilent, 8
      bind = $mainMod+SHIFT, 8, movetoworkspacesilent, 9
      bind = $mainMod+SHIFT, 9, movetoworkspacesilent, 10

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:273, hy3:movewindow
      bindm = $mainMod, mouse:272, resizewindow

      windowrulev2 = suppressevent maximize, class:.* # Prevent maximization of windows
      windowrulev2 = float, class:floating
      windowrulev2 = size 90% 90%, class:floating

      bind = $mainMod+SHIFT, Page_Down, hy3:movewindow, l, once
      bind = $mainMod+SHIFT, Page_Up, hy3:movewindow, r, once

      bind = $mainMod, Page_Down, hy3:focustab, l, prioritize_hovered
      bind = $mainMod, Page_Up, hy3:focustab, r, prioritize_hovered

      bind = $mainMod, z, hy3:makegroup, tab, , force_ephemeral
      bind = $mainMod, x, hy3:changegroup, untab

      bind = $mainMod+ALT, Page_Down, hy3:movefocus, l, visible, nowarp
      bind = $mainMod+ALT, Page_Up, hy3:movefocus, r, visible, nowarp
      bindel = ,XF86MonBrightnessDown, exec, hyprctl hyprsunset gamma -10
      bindel = ,XF86MonBrightnessUp, exec, hyprctl hyprsunset gamma +10

      bindel = SHIFT,XF86MonBrightnessDown, exec, hyprctl hyprsunset temperature -250
      bindel = SHIFT,XF86MonBrightnessUp, exec, hyprctl hyprsunset temperature +250

      plugin {
        hy3 {
          # disable gaps when only one window is onscreen
          # 0 - always show gaps
          # 1 - hide gaps with a single window onscreen
          # 2 - 1 but also show the window border
          no_gaps_when_only = 1

          # policy controlling what happens when a node is removed from a group,
          # leaving only a group
          # 0 = remove the nested group
          # 1 = keep the nested group
          # 2 = keep the nested group only if its parent is a tab group
          node_collapse_policy = 0 # default: 2

          # offset from group split direction when only one window is in a group
          group_inset = 10 # default: 10

          # if a tab group will automatically be created for the first window spawned in a workspace
          tab_first_window = false

          tabs {
            height = 6
            padding = 0
            from_top = true
            radius = 0

            border_width = 0
            render_text = false
            text_center = true
            text_font = Sans
            text_height = 8
            text_padding = 3

            # active tab bar segment colors
            col.active = rgb(${hexToRGBString "," config.colorScheme.palette.base0C})

            # focused tab bar segment colors (focused node in unfocused container)
            col.focused =  rgb(${hexToRGBString "," config.colorScheme.palette.base05})

            # inactive tab bar segment colors
            col.inactive = rgb(${hexToRGBString "," config.colorScheme.palette.base00})

            # urgent tab bar segment colors
            col.urgent =  rgba(ff223340)

            # locked tab bar segment colors
            col.locked =  rgba(90903340)

            blur = false
            opacity = 1.0
          }
        }
      }
    '';
  };
}
