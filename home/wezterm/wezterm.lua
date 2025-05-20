-- Define config
local config = {}

local wezterm = require("wezterm")
local theme = require("theme")
local opacity = theme.opacity
local font = require("font")
local keymaps = require("keymaps")

-- Provides better error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = theme.color_scheme
config.font_size = 20
config.use_fancy_tab_bar = false
config.window_background_opacity = opacity
config.adjust_window_size_when_changing_font_size = false
config.macos_window_background_blur = theme.blur
config.native_macos_fullscreen_mode = true
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.disable_default_key_bindings = true
config.show_new_tab_button_in_tab_bar = false
-- config.leader = keymaps.leader
config.keys = keymaps.general
config.font = font
config.tab_max_width = 40
config.colors = theme.colors

return config
