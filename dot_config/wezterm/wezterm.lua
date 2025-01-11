-- Pull in the wezterm API
local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.color_scheme = "nord"

config.font = wezterm.font("FiraCode Nerd Font")

config.enable_tab_bar = false

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

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
	{
		key = "H",
		mods = "CTRL",
		action = act.EmitEvent("trigger-test-dir"),
	},
}

-- nvim zen-mode
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("trigger-test-dir", function(window, pane)
	local cwd = wezterm.procinfo.current_working_dir_for_pid(wezterm.procinfo.pid())

	wezterm.log_info("test dir: " .. cwd)

	-- -- Create a temporary file to pass to vim
	-- local name = os.tmpname()
	-- local f = io.open(name, "w+")
	-- f:write(cwd)
	-- f:flush()
	-- f:close()
	--
	-- -- Open a new window running vim and tell it to open the file
	-- window:perform_action(
	-- 	act.SpawnCommandInNewWindow({
	-- 		args = { "nvim", name },
	-- 	}),
	-- 	pane
	-- )
	--
	-- -- Wait "enough" time for vim to read the file before we remove it.
	-- -- The window creation and process spawn are asynchronous wrt. running
	-- -- this script and are not awaitable, so we just pick a number.
	-- --
	-- -- Note: We don't strictly need to remove this file, but it is nice
	-- -- to avoid cluttering up the temporary directory.
	-- wezterm.sleep_ms(1000)
	-- os.remove(name)
end)

-- and finally, return the configuration to wezterm
return config
