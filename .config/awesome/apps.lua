local awful = require("awful")
local gears = require("gears")

local apps = {}

----------------
-- Default Apps
----------------
apps.defaults = {
	terminal = "alacritty",
	terminal_floating = "alacritty",
	browser = "chromium",
	text_editor = "alacritty -e nvim",
	spotify_tui = "spt",
	widget_terminal = "alacritty"
}

---------------
-- Widgets
---------------
apps.widgets = {
	spawn_spotify = function ()
		awful.spawn.with_shell(
			apps.defaults.widget_terminal ..
				" --class saturn-widget-spt" ..
				" --config-file ~/.config/alacritty/alacritty-widget.yml" ..
				" -e spt"
		)
	end,

	spawn_htop = function ()
		awful.spawn.with_shell(
			apps.defaults.terminal ..
				" --class saturn-widget-htop" ..
				" --config-file ~/.config/alacritty/alacritty-widget.yml" ..
				" -e htop"
		)
	end,

	spawn_slack = function ()
		awful.spawn.with_shell(
			apps.defaults.terminal ..
				" --class saturn-widget-slack" ..
				" --config-file ~/.config/alacritty/alacritty-widget.yml" ..
				" -e slack-term"
		)
	end
}

apps.widget_rules =
{
	{
		rule =
		{
			instance = "saturn-widget-spt"
		},
		properties =
		{
			border_width = 0,
			titlebars_enabled = false,
			raise = false,
			name = "Spotify",
			tag = "9",
			width = 500,
			height = 300
		}
	},
	{
		rule =
		{
			instance = "saturn-widget-slack"
		},
		properties =
		{
			border_width = 0,
			titlebars_enabled = false,
			raise = false,
			name = "Slack",
			tag = "9",
			width = 500,
			height = 300
		}
	},
	{
		rule =
		{
			instance = "saturn-widget-htop"
		},
		properties =
		{
			border_width = 0,
			titlebars_enabled = false,
			raise = false,
			name = "Htop",
			tag = "9",
			width = 500,
			height = 300
		}
	}
}

apps.rules = gears.table.join(apps.widget_rules)

return apps
