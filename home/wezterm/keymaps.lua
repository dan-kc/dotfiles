local wezterm = require("wezterm")
local act = wezterm.action

return {
	general = {
		{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(-1) },
		{ key = "PageUp", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
		{ key = "PageDown", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
		{ key = "+", mods = "CTRL", action = act.IncreaseFontSize }, -- Doesn't work
		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
		{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
		{ key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "X", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
		{ key = "V", mods = "CTRL|SHIFT", action = act.QuickSelect },
		-- {
		-- 	key = "2",
		-- 	mods = "OPT",
		-- 	action = act.SendString("€"),
		-- },
		-- {
		-- 	key = "3",
		-- 	mods = "OPT",
		-- 	action = act.SendString("#"),
		-- },
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
