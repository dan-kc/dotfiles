local wezterm = require("wezterm")
local act = wezterm.action

local theme = "Batman"

local merge_tables = function(first_table, second_table)
	for k, v in pairs(second_table) do
		first_table[k] = v
	end
	return first_table
end

local extract_tab_bar_colors_from_theme = function(theme_name)
	local wez_theme = wezterm.color.get_builtin_schemes()[theme_name]
	return {
		window_frame_colors = {
			active_titlebar_bg = wez_theme.background,
			inactive_titlebar_bg = wezterm.color.parse(wez_theme.background):darken(0.8),
		},
		tab_bar_colors = {
			inactive_tab_edge = wezterm.color.parse(wez_theme.background):darken(0.8),
			active_tab = {
				bg_color = wez_theme.brights[3],
				fg_color = wez_theme.background,
			},
			inactive_tab = {
				bg_color = wez_theme.background,
				fg_color = wez_theme.foreground,
			},
			inactive_tab_hover = {
				bg_color = wezterm.color.parse(wez_theme.background):lighten(0.1),
				fg_color = wezterm.color.parse(wez_theme.foreground):lighten(0.2),
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

config.font = wezterm.font("JetBrains Mono")

config.color_scheme = theme

config.font_size = 28

config.use_fancy_tab_bar = false

config.window_background_opacity = 0.9

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

	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "m", mods = "CMD", action = wezterm.action.Hide },
	{ key = "n", mods = "CMD", action = wezterm.action.SpawnWindow },
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	-- investigate
	{ key = "X", mods = "CMD|SHIFT", action = wezterm.action.ActivateCopyMode },
	{ key = "V", mods = "CMD|SHIFT", action = wezterm.action.QuickSelect },
}
config.quick_select_patterns = {}

-- Spawn a fish shell in login mode
-- config.default_prog = { "/opt/homebrew/bin/nu" }

config.window_frame = merge_tables({
	font = wezterm.font("Liga SFMono Nerd Font", { weight = "Medium" }),
}, tab_bar_theme.window_frame_colors)
config.colors = {
	tab_bar = tab_bar_theme.tab_bar_colors,
}

return config