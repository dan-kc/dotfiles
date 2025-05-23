local wezterm = require("wezterm")
local opacity = 0.98
local color_scheme = "Rosé Pine (base16)" -- 8/10
-- local color_scheme = "Rosé Pine Moon (base16)"
-- local color_scheme = "Snazzy (base16)"
-- local color_scheme = "Chalk (base16)"
-- local color_scheme = "Circus (base16)"
-- local color_scheme = "Solar Flare (base16)"
-- local color_scheme = "Qualia (base16)"
-- local color_scheme = "Materia (base16)"
-- local color_scheme = "Material Darker (base16)"
-- local color_scheme = "Gigavolt (base16)"
-- local color_scheme = "darkmoss (base16)"
-- local color_scheme = "OceanicNext (base16)"
-- local color_scheme = "Ashes (base16)"
-- local color_scheme = "Framer (base16)"
-- local color_scheme = "Monokai (base16)"
-- local color_scheme = "Porple (base16)" -- 10/10
-- local color_scheme = "Rebecca (base16)" -- 8/10
-- local color_scheme = "Twilight (base16)" -- 6/10
-- local color_scheme = "Harmonic16 Dark (base16)" -- 7/10
-- local color_scheme = "DanQing (base16)" -- 7/10
-- local color_scheme = "Eighties (base16)" 
-- local color_scheme = "Gruvbox dark, pale (base16)"
-- local color_scheme = "Kimber (base16)"

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
	}
end

local tab_bar_color_scheme = extract_tab_bar_colors_from_theme(color_scheme)

return {
	opacity = opacity,
	color_scheme = color_scheme,
	colors = {
		tab_bar = tab_bar_color_scheme,
	},
	blur = blur,
}
