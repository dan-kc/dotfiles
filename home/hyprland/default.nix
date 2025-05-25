{
  pkgs,
  inputs,
  ...
}:
{
  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
    '';
    ".config/hypr/hyprland.conf".text = ''
      plugin = ${inputs.hy3.packages.x86_64-linux.hy3}/lib/libhy3.so
      monitor=,highrr,auto,auto

      $terminal = alacritty
      $browser = vivaldi
      $menu = bemenu-run

      exec-once = udiskie
      exec-once = hyprpaper & sleep 0.5 && theme-switch
      exec-once = hyprsunset

      env = XCURSOR_SIZE,10
      env = HYPRCURSOR_SIZE,24

      general { 
          gaps_in = 5.5
          gaps_out = 8
          border_size = 0

          # Disable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false 

          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = hy3
      }

      decoration {
          rounding = 10
          active_opacity = 1.0
          inactive_opacity = 0.94
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

      input {
          repeat_rate = 25
          repeat_delay = 150
          follow_mouse = 1
          natural_scroll = true
          scroll_factor = 0.5
          kb_layout = us,gb
      }

      gestures {
          workspace_swipe = false
      }

      device {
          name = bastard-keyboards-charybdis-nano-(3x5)-splinky-mouse
          sensitivity = -0.9
      }

      $mainMod = WIN # Sets "Windows" key as main modifier
      $paste = CLIPBOARD_NOGUI=1 cb history | cat | jq -r '.[].content | select(. != null)' | bemenu | wl-copy
      $copy = wl-paste | CLIPBOARD_NOGUI=1 cb copy
      $screenshot = grim -g '$(slurp)'

      bind = $mainMod, J, exec, alacritty --working-directory ~/notes --class floating --command nvim $(jt)
      bind = $mainMod, Y, exec, alacritty --working-directory ~/ --class floating --command yazi
      bind = $mainMod, T, exec, alacritty -e bash -c 'selected_dir=$(zoxide query -l | fzf --preview "ls {}"); if [ -n "$selected_dir" ]; then cd "$selected_dir"; fi; exec zsh'

      env = HYPRCURSOR_THEME,rose-pine-hyprcursor

      # Screenshot a window
      bind = $mainMod, PRINT, exec, hyprshot -m window
      # Screenshot a monitor
      bind = , PRINT, exec, hyprshot -m output
      # Screenshot a region
      bind = $shiftMod, PRINT, exec, hyprshot -m region

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
      bind = $mainMod ALT, 0, movetoworkspacesilent, 1
      bind = $mainMod ALT, 1, movetoworkspacesilent, 2
      bind = $mainMod ALT, 2, movetoworkspacesilent, 3
      bind = $mainMod ALT, 3, movetoworkspacesilent, 4
      bind = $mainMod ALT, 4, movetoworkspacesilent, 5
      bind = $mainMod ALT, 5, movetoworkspacesilent, 6
      bind = $mainMod ALT, 6, movetoworkspacesilent, 7
      bind = $mainMod ALT, 7, movetoworkspacesilent, 8
      bind = $mainMod ALT, 8, movetoworkspacesilent, 9
      bind = $mainMod ALT, 9, movetoworkspacesilent, 10

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
      bind = $mainMod, a, hy3:changefocus, top

      # bind = $mainMod, d, hy3:makegroup, h, , force_ephemeral
      # bind = $mainMod, s, hy3:makegroup, v, , force_ephemeral

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

          # tab group settings
          tabs {
            # height of the tab bar
            height = 10
            padding = 0 # default: 6
            from_top = true 
            radius = 10 # default: 6

            border_width = 0 
            render_text = false
            text_center = true # default: true
            text_font = Sans # default: Sans
            text_height = 8 # default: 8
            text_padding = 3 # default: 3

            # active tab bar segment colors
            col.active = rgba(33ccff40)
            col.active.border = rgba(33ccffee)
            col.active.text = rgba(ffffffff)

            # focused tab bar segment colors (focused node in unfocused container)
            col.focused =  rgba(60606040)
            col.focused.border =  rgba(808080ee)
            col.focused.text =  rgba(ffffffff)

            # inactive tab bar segment colors
            col.inactive =  rgba(30303020)
            col.inactive.border =  rgba(606060aa)
            col.inactive.text =  rgba(ffffffff)

            # urgent tab bar segment colors
            col.urgent =  rgba(ff223340)
            col.urgent.border =  rgba(ff2233ee)
            col.urgent.text =  rgba(ffffffff)

            # urgent tab bar segment colors
            col.locked =  rgba(90903340)
            col.locked.border =  rgba(909033ee)
            col.locked.text =  rgba(ffffffff)

            # if tab backgrounds should be blurred
            # Blur is only visible when the above colors are not opaque.
            blur = true # default: true

            # opacity multiplier for tabs
            # Applies to blur as well as the given colors.
            opacity = 1.0 # default: 1.0
          }

          # autotiling settings
          autotile {
            # enable autotile
            enable = false # default: false

            # make autotile-created groups ephemeral
            ephemeral_groups = true # default: true

            # if a window would be squished smaller than this width, a vertical split will be created
            # -1 = never automatically split vertically
            # 0 = always automatically split vertically
            # <number> = pixel width to split at
            trigger_width = 0 # default: 0

            # if a window would be squished smaller than this height, a horizontal split will be created
            # -1 = never automatically split horizontally
            # 0 = always automatically split horizontally
            # <number> = pixel height to split at
            trigger_height = 0 # default: 0

            # a space or comma separated list of workspace ids where autotile should be enabled
            # it's possible to create an exception rule by prefixing the definition with "not:"
            # workspaces = 1,2 # autotiling will only be enabled on workspaces 1 and 2
            # workspaces = not:1,2 # autotiling will be enabled on all workspaces except 1 and 2
            workspaces = all # default: all
          }
        }
      }
    '';
  };
  home.packages = with pkgs; [
    hyprpaper
    hyprshot
    hyprsunset
  ];
}
