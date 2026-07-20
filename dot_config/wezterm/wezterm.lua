-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- For example, changing the color scheme:
config.color_scheme = "nord"

config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"Noto Emoji",
})
config.font_size = 11.0

config.enable_tab_bar = false

config.initial_cols = 1000
config.initial_rows = 300

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.window_background_opacity = 0.9

-- make PENG jira issue ids clickable
table.insert(config.hyperlink_rules, {
	regex = [[\bPENG-(\d+)\b]],
	format = "https://candosa.atlassian.net/browse/PENG-$1",
})

local hyperlink_rules = {
	{
		regex = "PENG%-(%d+)",
		format = "https://candosa.atlassian.net/browse/PENG-$1",
	},
}

config.keys = {
	{
		key = "E",
		mods = "CTRL",
		action = wezterm.action({
			QuickSelectArgs = {
				patterns = {
					"https?://\\S+",
					"\\bPENG-\\d+\\b", -- Add Jira issue ID pattern
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)
					-- Loop through hyperlink_rules to check for matches
					for _, rule in ipairs(hyperlink_rules) do
						local matches = { url:match(rule.regex) }
						if #matches > 0 then
							-- Replace the format placeholders with captured groups
							url = rule.format:gsub("%$(%d+)", function(index)
								return matches[tonumber(index)] or ""
							end)
							break -- Stop looping after the first match
						end
					end
					wezterm.log_info("opening: " .. url)
					wezterm.open_with(url)
				end),
			},
		}),
	},
}

-- and finally, return the configuration to wezterm
return config
