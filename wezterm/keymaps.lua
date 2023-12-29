local wezterm = require("wezterm")
local act = wezterm.action

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
