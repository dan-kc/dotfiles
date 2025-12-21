{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  home.file = {
    ".config/wezterm/wezterm.lua".text = ''
      -- Define config
      local config = {}

      local wezterm = require("wezterm")
      -- local font = require("font")
      local keymaps = require("keymaps")

      -- Provides better error messages
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.font_size = 30
      config.use_fancy_tab_bar = false
      config.window_background_opacity = opacity
      config.adjust_window_size_when_changing_font_size = false
      config.native_macos_fullscreen_mode = true
      config.window_decorations = "RESIZE"
      config.hide_tab_bar_if_only_one_tab = true
      config.disable_default_key_bindings = true
      config.show_new_tab_button_in_tab_bar = false
      -- config.leader = keymaps.leader
      config.keys = keymaps.general
      -- config.font = font
      -- config.default_prog = { "/opt/homebrew/bin/nu", "-l" }
      config.tab_max_width = 40
      config.colors = require("theme")

      return config
    '';
    ".config/wezterm/theme.lua".text = ''
      local wezterm = require("wezterm")

      local colors = {
        foreground = '#${config.colorScheme.palette.base05}',
        background = '#${config.colorScheme.palette.base00}',
        cursor_bg = '#${config.colorScheme.palette.base05}',
        cursor_fg = '#${config.colorScheme.palette.base00}',

        -- Specifies the border color of the cursor when the cursor style is set to Block,
        -- or the color of the vertical or horizontal bar when the cursor style is set to
        -- Bar or Underline.
        cursor_border = '#${config.colorScheme.palette.base05}',

        -- the foreground color of selected text
        selection_fg = '#${config.colorScheme.palette.base00}',
        -- the background color of selected text
        selection_bg = '#${config.colorScheme.palette.base05}',

        -- The color of the scrollbar "thumb"; the portion that represents the current viewport
        scrollbar_thumb = '#${config.colorScheme.palette.base01}',

        -- The color of the split lines between panes
        split = '#${config.colorScheme.palette.base03}',

        -- Normal colors (ansi)
        ansi = {
          '#${config.colorScheme.palette.base00}', -- black
          '#${config.colorScheme.palette.base08}', -- red
          '#${config.colorScheme.palette.base0B}', -- green
          '#${config.colorScheme.palette.base0A}', -- yellow
          '#${config.colorScheme.palette.base0D}', -- blue
          '#${config.colorScheme.palette.base0E}', -- magenta
          '#${config.colorScheme.palette.base0C}', -- cyan
          '#${config.colorScheme.palette.base05}', -- white
        },
        -- Bright colors
        brights = {
          '#${config.colorScheme.palette.base03}', -- bright black
          '#${config.colorScheme.palette.base08}', -- bright red
          '#${config.colorScheme.palette.base0B}', -- bright green
          '#${config.colorScheme.palette.base0A}', -- bright yellow
          '#${config.colorScheme.palette.base0D}', -- bright blue
          '#${config.colorScheme.palette.base0E}', -- bright magenta (purple)
          '#${config.colorScheme.palette.base0C}', -- bright cyan
          '#${config.colorScheme.palette.base07}', -- bright white
        },

        compose_cursor = '#${config.colorScheme.palette.base0E}',

        copy_mode_active_highlight_bg = { Color = '#${config.colorScheme.palette.base02}' },
        copy_mode_active_highlight_fg = { Color = '#${config.colorScheme.palette.base05}' },
        copy_mode_inactive_highlight_bg = { Color = '#${config.colorScheme.palette.base01}' },
        copy_mode_inactive_highlight_fg = { Color = '#${config.colorScheme.palette.base05}' },

        quick_select_label_bg = { Color = '#${config.colorScheme.palette.base0A}' },
        quick_select_label_fg = { Color = '#${config.colorScheme.palette.base00}' },
        quick_select_match_bg = { Color = '#${config.colorScheme.palette.base0D}' },
        quick_select_match_fg = { Color = '#${config.colorScheme.palette.base00}' },
      }

      tab_bar = {
        background = colors.background,
        active_tab = {
          bg_color = colors.brights[5],
          fg_color = colors.background,
        },
        inactive_tab = {
          fg_color = colors.foreground,
          bg_color = colors.background,
        },
        inactive_tab_hover = {
          bg_color = colors.background,
          fg_color = colors.foreground,
        },
        new_tab = {
          bg_color = colors.background,
          fg_color = colors.foreground,
        },
        new_tab_hover = {
          bg_color = colors.brights[5],
          fg_color = colors.background,
        },
      }

      colors.tab_bar = tab_bar
      return colors
    '';
    ".config/wezterm/keymaps.lua".text = ''
      local wezterm = require("wezterm")
      local act = wezterm.action

      local process_icons = {
        ["docker"] = {
          { Text = wezterm.nerdfonts.linux_docker },
        },
        ["docker-compose"] = {
          { Text = wezterm.nerdfonts.linux_docker },
        },
        ["kuberlr"] = {
          { Text = wezterm.nerdfonts.linux_docker },
        },
        ["kubectl"] = {
          { Text = wezterm.nerdfonts.linux_docker },
        },
        ["nvim"] = {
          { Text = wezterm.nerdfonts.custom_vim },
        },
        ["vim"] = {
          { Text = wezterm.nerdfonts.dev_vim },
        },
        ["node"] = {
          { Text = wezterm.nerdfonts.mdi_hexagon },
        },
        ["zsh"] = {
          { Text = wezterm.nerdfonts.cod_terminal },
        },
        ["bash"] = {
          { Text = wezterm.nerdfonts.cod_terminal_bash },
        },
        ["btm"] = {
          { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
        },
        ["htop"] = {
          { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
        },
        ["cargo"] = {
          { Text = wezterm.nerdfonts.dev_rust },
        },
        ["go"] = {
          { Text = wezterm.nerdfonts.mdi_language_go },
        },
        ["lazydocker"] = {
          { Text = wezterm.nerdfonts.linux_docker },
        },
        ["git"] = {
          { Text = wezterm.nerdfonts.dev_git },
        },
        ["lua"] = {
          { Text = wezterm.nerdfonts.seti_lua },
        },
        ["wget"] = {
          { Text = wezterm.nerdfonts.mdi_arrow_down_box },
        },
        ["curl"] = {
          { Text = wezterm.nerdfonts.mdi_flattr },
        },
        ["gh"] = {
          { Text = wezterm.nerdfonts.dev_github_badge },
        },
        ["python"] = {
          { Text = wezterm.nerdfonts.dev_python },
        },
        ["python3"] = {
          { Text = wezterm.nerdfonts.dev_python },
        },
        ["ruby"] = {
          { Text = wezterm.nerdfonts.dev_ruby },
        },
        ["beam.smp"] = {
          { Text = wezterm.nerdfonts.custom_elixir },
        },
        ["elixir"] = {
          { Text = wezterm.nerdfonts.custom_elixir },
        },
      }

      local function get_current_working_dir(tab)
        local current_dir = tab.active_pane.current_working_dir
        local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

        if current_dir == HOME_DIR then
          return "~"
        end

        return string.gsub(current_dir, "(.*[/\\])(.*)", "%2")
      end

      local function get_process(tab)
        local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
        if string.find(process_name, "kubectl") then
          process_name = "kubectl"
        end

        return wezterm.format(process_icons[process_name] or { { Text = string.format("%s:", process_name) } })
      end

      wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        local has_unseen_output = false
        if not tab.is_active then
          for _, pane in ipairs(tab.panes) do
            if pane.has_unseen_output then
              has_unseen_output = true
              break
            end
          end
        end

        local title = string.format("%s  %s", get_process(tab), get_current_working_dir(tab))

        if tab.active_pane.is_zoomed then
          title = title .. " " .. wezterm.nerdfonts.md_alpha_z_box
        end

        if has_unseen_output then
          return {
            { Foreground = { Color = "#bb9af7" } },
            { Text = title },
          }
        end

        return {
          { Text = title },
        }
      end)

      return {
        general = {
          { key = "LeftArrow", mods = "ALT|CMD", action = act.ActivateTabRelative(-1) },
          { key = "RightArrow", mods = "ALT|CMD", action = act.ActivateTabRelative(1) },
          { key = "PageUp", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
          { key = "PageDown", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
          { key = "+", mods = "CMD", action = act.IncreaseFontSize },
          { key = "-", mods = "CMD", action = act.DecreaseFontSize },
          { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
          { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
          { key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = false }) },
          { key = "m", mods = "CMD", action = act.Hide },
          { key = "n", mods = "CMD", action = act.SpawnWindow },
          { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
          { key = "X", mods = "CMD|SHIFT", action = act.ActivateCopyMode },
          { key = "V", mods = "CMD|SHIFT", action = act.QuickSelect },
          {
            key = "2",
            mods = "OPT",
            action = act.SendString("€"),
          },
          {
            key = "3",
            mods = "OPT",
            action = act.SendString("#"),
          },
          {
            mods = "CMD",
            key = ".",
            action = wezterm.action.SpawnCommandInNewTab({
              cwd = os.getenv("HOME") .. "/dotfiles",
            }),
          },
          {
            mods = "CMD|ALT",
            key = "n",
            action = wezterm.action.SpawnCommandInNewTab({
              cwd = os.getenv("HOME") .. "/notes",
            }),
          },
          {
            mods = "CMD",
            key = "p",
            action = act.ActivateCommandPalette,
          },
        },
        -- leader = {
        -- 	key = "Space",
        -- 	mods = "CTRL",
        -- 	timeout_milliseconds = 1000,
        -- },
      }
    '';
    ".config/wezterm/font.lua".text = ''
      local wezterm = require("wezterm")
      -- return wezterm.font("GeistMono Nerd Font")
      -- return wezterm.font("Hack Nerd Font")
      -- return wezterm.font("Hasklug Nerd Font")
      -- return wezterm.font("Monofur Nerd Font")
      return wezterm.font("Hurmit Nerd Font")
      -- return wezterm.font("FiraCode Nerd Font")
      -- return wezterm.font("Agave Nerd Font")
      -- return wezterm.font("Mononoki Nerd Font")
      -- return wezterm.font("Overpass Nerd Font")
    '';
  };
}
