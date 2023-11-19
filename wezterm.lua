local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
local opacity = 0.9

local theme = "Rosé Pine (base16)"
-- local theme = "Rosé Pine Moon (base16)"
-- local theme = "Snazzy (base16)"
-- local theme = "Chalk (base16)"
-- local theme = "Circus (base16)"
-- local theme = "Solar Flare (base16)"
-- local theme = "Qualia (base16)"
-- local theme = "Materia (base16)"
-- local theme = "Material Darker (base16)"
-- local theme = "Gigavolt (base16)"
-- local theme = "darkmoss (base16)"
-- local theme = "OceanicNext (base16)"
-- local theme = "Ashes (base16)"
-- local theme = "Framer (base16)"
-- local theme = "Monokai (base16)"
-- local theme = "Porple (base16)"
-- local theme = "Rebecca (base16)"
-- local theme = "Twilight (base16)"
-- local theme = "Black Metal (base16)"
-- local theme = "Brewer (base16)"
-- local theme = "Harmonic16 Dark (base16)"
-- local theme = "Classic Dark (base16)"
-- local theme = "DanQing (base16)"
-- local theme = "Eighties (base16)"
-- local theme = "Gruvbox dark, pale (base16)"
-- local theme = "Kimber (base16)"

-- config.font = wezterm.font("Fira Code")
-- config.font = wezterm.font("Hurmit Nerd Font")
-- config.font = wezterm.font("FiraCode Nerd Font")
config.font = wezterm.font("Mononoki Nerd Font")
-- config.font = wezterm.font("JetBrains Mo")

local new_opacity = function(c, o)
	local color = wezterm.color
	local h, s, l = color.parse(c):hsla()
	local str = "hsla(" .. h .. "," .. s * 100 .. "%," .. l * 100 .. "%," .. o * 100 .. "%)"
	return str
end

local extract_tab_bar_colors_from_theme = function(theme_name)
	-- Get current theme
	local color = wezterm.color
	local wez_theme = color.get_builtin_schemes()[theme_name]

	return {
		tab_bar_colors = {
			-- inactive_tab_edge = new_opacity(wez_theme.background, opacity),
			background = new_opacity(wez_theme.background, opacity),
			active_tab = {
				bg_color = new_opacity(wez_theme.brights[5], opacity),
				fg_color = new_opacity(wez_theme.background, opacity),
			},
			inactive_tab = {
				fg_color = new_opacity(wez_theme.foreground, opacity),
				bg_color = new_opacity(wez_theme.background, opacity),
			},
			inactive_tab_hover = {
				bg_color = new_opacity(wez_theme.background, opacity),
				fg_color = new_opacity(wez_theme.foreground, opacity),
			},
			new_tab = {
				bg_color = new_opacity(wez_theme.background, opacity),
				fg_color = new_opacity(wez_theme.foreground, opacity),
			},
			new_tab_hover = {
				bg_color = new_opacity(wez_theme.brights[5], opacity),
				fg_color = new_opacity(wez_theme.background, opacity),
			},
		},
	}
end

local tab_bar_theme = extract_tab_bar_colors_from_theme(theme)

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = theme
config.font_size = 20
config.use_fancy_tab_bar = false

config.window_background_opacity = opacity

config.adjust_window_size_when_changing_font_size = false
config.macos_window_background_blur = 35
config.native_macos_fullscreen_mode = true
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.disable_default_key_bindings = true

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "LeftArrow", mods = "ALT|CMD", action = act.ActivateTabRelative(-1) },
	{ key = "RightArrow", mods = "ALT|CMD", action = act.ActivateTabRelative(1) },

	{ key = "PageUp", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
	{ key = "PageDown", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },

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

	{
		key = "2",
		mods = "OPT",
		action = wezterm.action.SendString("€"),
	},
	{
		key = "3",
		mods = "OPT",
		action = wezterm.action.SendString("#"),
	},
}

config.default_prog = { "/opt/homebrew/bin/nu", "-l" }

config.tab_max_width = 40
config.window_frame = tab_bar_theme.window_frame_colors
config.colors = {
	tab_bar = tab_bar_theme.tab_bar_colors,
}

return config
