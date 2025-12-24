-- Pull in the wezterm API
local wezterm = require("wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local sessions = wezterm.plugin.require("https://github.com/abidibo/wezterm-sessions")

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

-- This is where you actually apply your config choices

config.font = wezterm.font("JetBrains Mono Nerd Font")
config.font_size = 14

config.color_scheme = "Maia (Gogh)"

config.enable_tab_bar = true
config.show_tabs_in_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

config.keys = {
	{ key = "a", mods = "SUPER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	{ key = "L", mods = "ALT", action = wezterm.action.ShowLauncher },
	{ key = "t", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },
	{ key = "d", mods = "ALT", action = workspace_switcher.switch_workspace() },
	{
		key = "p",
		mods = "ALT",
		action = workspace_switcher.switch_to_prev_workspace(),
	},

	{
		key = "r",
		mods = "ALT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Rename current workspace
	{
		key = "a",
		mods = "ALT",
		action = act.PromptInputLine({
			description = "Enter new workspace name",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},

	{
		key = "w",
		mods = "ALT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	-- {
	-- 	key = "s",
	-- 	mods = "CTRL|SHIFT",
	-- 	action = act({ EmitEvent = "save_session" }),
	-- },
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act({ EmitEvent = "load_session" }),
	},
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = act({ EmitEvent = "restore_session" }),
	},
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = act({ EmitEvent = "delete_session" }),
	},
	{
		key = "e",
		mods = "CTRL|SHIFT",
		action = act({ EmitEvent = "edit_session" }),
	},

	{
		key = "h",
		mods = "CTRL",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{ key = "k", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
	{
		key = "l",
		mods = "CTRL",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
}

config.default_workspace = "~"

workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Text = "󱂬: " .. label },
	})
end

wezterm.on("update-right-status", function(window, pane)
	-- Show active workspace in right status
	local workspace = window:active_workspace()
	window:set_right_status("🌐 " .. workspace)
end)

-- Auto-save session every 5 minutes (300 seconds)
wezterm.on("gui-startup", function(window)
	wezterm.time.call_after(300, function()
		wezterm.emit("save_session")
	end)
end)

-- Re-trigger the timer every time a save happens to create a loop
wezterm.on("save_session", function(window)
	wezterm.time.call_after(300, function()
		wezterm.emit("save_session")
	end)
end)

-- and finally, return the configuration to wezterm
return config
