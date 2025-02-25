local wezterm = require("wezterm")
local act = wezterm.action

return {
	general = {
		{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(-1) },

		{ key = "PageUp", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
		{ key = "PageDown", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },

		{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },

		{ key = "V", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
		{ key = "C", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },

		{ key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },

		{ key = "Y", mods = "CTRL|SHIFT", action = act.ActivateCopyMode }, -- Copy mode not currently working
		{ key = "G", mods = "CTRL|SHIFT", action = act.QuickSelect },
		{
			mods = "CMD",
			key = "p",
			action = act.ActivateCommandPalette,
		},
	},
}
