local current = dofile(os.getenv("HOME") .. "/.config/theme/current.lua")
local path = os.getenv("HOME") .. "/.config/theme/" .. current .. ".lua"
local theme = dofile(path)
local settings = theme.settings
local opacity = settings.opacity
local blur = settings.blur

-- Helpers
local hex2rgba = function(hex, a)
	local hex = hex:gsub("#", "") -- Remove the #
	local r = tonumber("0x" .. hex:sub(1, 2))
	local g = tonumber("0x" .. hex:sub(3, 4))
	local b = tonumber("0x" .. hex:sub(5, 6))
	return "rgba(" .. r .. "," .. g .. "," .. b .. "," .. a .. ")"
end

-- Tabbar
local tab_bar_color_scheme = {
	background = hex2rgba(theme.normal.black, opacity),
	active_tab = {
		bg_color = hex2rgba(theme.brights.blue, opacity),
		fg_color = hex2rgba(theme.normal.black, opacity),
	},
	inactive_tab = {
		bg_color = hex2rgba(theme.normal.black, opacity),
		fg_color = hex2rgba(theme.brights.white, opacity),
	},
	inactive_tab_hover = {
		bg_color = hex2rgba(theme.brights.white, opacity),
		fg_color = hex2rgba(theme.normal.black, opacity),
	},
	new_tab = {
		bg_color = hex2rgba(theme.normal.black, opacity),
		fg_color = hex2rgba(theme.brights.white, opacity),
	},
	new_tab_hover = {
		bg_color = hex2rgba(theme.brights.blue, opacity),
		fg_color = hex2rgba(theme.normal.black, opacity),
	},
}

local colors = {
	ansi = {
		theme.normal.black,
		theme.normal.red,
		theme.normal.green,
		theme.normal.yellow,
		theme.normal.blue,
		theme.normal.magenta,
		theme.normal.cyan,
		theme.normal.white,
	},
	background = theme.normal.black,
	brights = {
		theme.brights.black,
		theme.brights.red,
		theme.brights.green,
		theme.brights.yellow,
		theme.brights.blue,
		theme.brights.magenta,
		theme.brights.cyan,
		theme.brights.white,
	},
	cursor_bg = theme.normal.white,
	cursor_border = theme.normal.black, -- Only used if blinking cursor
	cursor_fg = theme.normal.black,
	foreground = theme.normal.white,

	selection_bg = theme.normal.white,
	selection_fg = theme.normal.black,

	-- scrollbar_thumb = theme.brights.white, -- Only used if scrollbar is set
	-- split = theme.brights.black,
	-- compose_cursor = theme.brights.red,
	-- copy_mode_active_highlight_bg = { Color = "#000000" },
	-- copy_mode_active_highlight_fg = { AnsiColor = "Black" },
	-- copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
	-- copy_mode_inactive_highlight_fg = { AnsiColor = "White" },
	-- quick_select_label_bg = { Color = "peru" },
	-- quick_select_label_fg = { Color = "#ffffff" },
	-- quick_select_match_bg = { AnsiColor = "Navy" },
	-- quick_select_match_fg = { Color = "#ffffff" },
	tab_bar = tab_bar_color_scheme,
}

return {
	opacity = opacity,
	colors = colors,
	blur = blur,
}
