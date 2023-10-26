local wezterm = require("wezterm")
local act = wezterm.action

local theme = "Rosé Pine (base16)"

local extract_tab_bar_colors_from_theme = function(theme_name)
	local wez_theme = wezterm.color.get_builtin_schemes()[theme_name]
	return {
		window_frame_colors = {
			active_titlebar_bg = wez_theme.background,
			inactive_titlebar_bg = wez_theme.background,
		},
		tab_bar_colors = {
			inactive_tab_edge = wez_theme.background,
			active_tab = {
				bg_color = wez_theme.brights[3],
				fg_color = wez_theme.background,
			},
			inactive_tab = {
				bg_color = wez_theme.background,
				fg_color = wez_theme.foreground,
			},
			inactive_tab_hover = {
				bg_color = wez_theme.background,
				fg_color = wez_theme.foreground,
			},
			new_tab = {
				bg_color = wez_theme.background,
				fg_color = wez_theme.foreground,
			},
			new_tab_hover = {
				bg_color = wez_theme.brights[3],
				fg_color = wez_theme.background,
			},
		},
	}
end

local tab_bar_theme = extract_tab_bar_colors_from_theme(theme)
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font("Hack Nerd Font")
config.color_scheme = theme
config.font_size = 28
config.use_fancy_tab_bar = true

config.window_background_opacity = 0.95

config.adjust_window_size_when_changing_font_size = false
config.macos_window_background_blur = 20
config.native_macos_fullscreen_mode = true
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.disable_default_key_bindings = true

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "LeftArrow", mods = "ALT|CMD", action = act.ActivateTabRelative(-1) },
	{ key = "RightArrow", mods = "ALT|CMD", action = act.ActivateTabRelative(1) },

	{ key = "LeftArrow", mods = "SHIFT|ALT|CMD", action = act.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "SHIFT|ALT|CMD", action = act.MoveTabRelative(1) },

	{ key = "+", mods = "CMD", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },

	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },

	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "m", mods = "CMD", action = wezterm.action.Hide },
	{ key = "n", mods = "CMD", action = wezterm.action.SpawnWindow },
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	{ key = "X", mods = "CMD|SHIFT", action = wezterm.action.ActivateCopyMode },
	{ key = "V", mods = "CMD|SHIFT", action = wezterm.action.QuickSelect },
}

config.default_prog = { "/opt/homebrew/bin/nu", "-l" }

config.window_frame = tab_bar_theme.window_frame_colors
config.colors = {
	tab_bar = tab_bar_theme.tab_bar_colors,
}

return config
