-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.color_scheme = "nord"

config.font = wezterm.font("FiraCode Nerd Font Mono")

config.enable_tab_bar = false

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make ARCH0 jira issue ids clickable
table.insert(config.hyperlink_rules, {
	regex = [[\bARCH0-(\d+)\b]],
	format = "https://platformcy.atlassian.net/browse/ARCH0-$1",
})

config.keys = {
	{
		key = "E",
		mods = "CTRL",
		action = wezterm.action({
			QuickSelectArgs = {
				patterns = {
					"https?://\\S+",
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)
					wezterm.log_info("opening: " .. url)
					wezterm.open_with(url)
				end),
			},
		}),
	},
}

-- and finally, return the configuration to wezterm
return config
