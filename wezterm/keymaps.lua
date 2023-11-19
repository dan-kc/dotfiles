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
