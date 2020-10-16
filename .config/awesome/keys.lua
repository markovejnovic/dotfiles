-- Awesome Dependencies
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

-- Local Dependencies
local layout = require('layout')
local utils = require("utils")
local decorations = require("decorations")
local apps = require("apps")

SUPER = "Mod4"
ALT = "Mod1"
CTRL = "Control"
SHIFT = "Shift"

local keys = {}

keys.global = gears.table.join(
	-- Launcher Keys
	awful.key({ SUPER }, "d",
		function ()
			awful.spawn.with_shell("rofi -matching fuzzy -show combi")
		end,
		{
			description = "Spawn ROFI",
			group = "launcher"
		}
	),

	awful.key({ SUPER }, "Return",
		function ()
			awful.spawn(apps.defaults.terminal)
		end,
		{
			description = "Spawn the terminal",
			group = "launcher"
		}
	),

	awful.key({}, "Print",
		function ()
			awful.spawn.with_shell('flameshot gui')
		end,
		{
			description = "Spawn Flameshot",
			group = "launcher",
		}
	),

	-----------------
	-- Awesome Util
	-----------------
	awful.key({ SUPER, SHIFT }, "r",
		awesome.restart,
		{
			description = "Reload AwesomeWM",
			group = "awesome"
		}
	),

	awful.key({ SUPER, SHIFT }, "e",
		exit_screen_show,
		{
			description = "Exit AwesomeWM",
			group = "awesome"
		}
	),

	awful.key({}, "XF86PowerOff",
		exit_screen_show,
		{
			description = "Exit AwesomeWM",
			group = "awesome"
		}
	),

	-----------------
	-- Layout Control
	-----------------
	awful.key({ SUPER }, 'f',
		layout.toggle_max,
		{
			description = 'Maximize',
			group = 'layout'
		}
	),

	awful.key({ SUPER }, 'v',
		layout.toggle_tiling,
		{
			description = 'Tile',
			group = 'layout'
		}
	),

	awful.key({ SUPER }, 'b',
		function ()
			awful.layout.inc(-1)
		end,
		{
			description = 'Decrement the layout',
			group = 'layout'
		}
	),

	awful.key({ SUPER }, 'n',
		function ()
			awful.layout.inc(1)
		end,
		{
			description = 'Increment the layout',
			group = 'layout'
		}
	),
	
	-----------------
	-- Hardware Keys
	-----------------
	
	-- Audio
	awful.key({}, "XF86AudioMute",
		utils.alsa.mute_t,
		{
			description = "Toggle Mute Audio",
			group = "hardware"
		}
	),

	awful.key({}, "XF86AudioLowerVolume",
		function ()
			utils.alsa.inc_vol(-5)
		end,
		{
			description = "Decrease Volume",
			group = "hardware"
		}
	),

	awful.key({}, "XF86AudioRaiseVolume",
		function ()
			utils.alsa.inc_vol(5)
		end,
		{
			description = "Increase Volume",
			group = "hardware"
		}
	),

	awful.key({ SHIFT }, "XF86AudioLowerVolume",
		function ()
			utils.alsa.inc_vol(-1)
		end,
		{
			description = "Precise Decrease Volume",
			group = "hardware"
		}
	),

	awful.key({ SHIFT }, "XF86AudioRaiseVolume",
		function ()
			utils.alsa.inc_vol(1)
		end,
		{
			description = "Precise Increase Volume",
			group = "hardware"
		}
	),


	-----------------
	-- Client Keys
	-----------------

	-- Focus Keys
	-----------------
	awful.key({ SUPER }, "h",
		function ()
			awful.client.focus.bydirection("left")
		end,
		{
			description = "Focus Left",
			group = "client"
		}
	),

	awful.key({ SUPER }, "l",
		function ()
			awful.client.focus.bydirection("right")
		end,
		{
			description = "Focus Right",
			group = "client"
		}
	),

	awful.key({ SUPER }, "j",
		function ()
			awful.client.focus.bydirection("down")
		end,
		{
			description = "Focus Down",
			group = "client"
		}
	),

	awful.key({ SUPER }, "k",
		function ()
			awful.client.focus.bydirection("up")
		end,
		{
			description = "Focus Up",
			group = "client"
		}
	),

	-- Resize Keys
	-----------------

	awful.key({ SUPER, ALT }, 'j',
		function ()
			awful.client.incwfact(-0.01)
		end,
		{
			description = "Resize Up",
			group = "client"
		}
	),

	awful.key({ SUPER, ALT }, 'k',
		function ()
			awful.client.incwfact(0.01)
		end,
		{
			description = "Resize Down",
			group = "client"
		}
	),

	awful.key({ SUPER, ALT }, 'l',
		function ()
			awful.client.incwfact(0.01)
		end,
		{
			description = "Resize Right",
			group = "client"
		}
	),

	-- Move Keys
	-----------------
	awful.key({ SUPER, SHIFT }, 'h',
		function ()
			awful.client.swap.byidx(1)
		end,
		{
			description = "Swap Up",
			group = "client"
		}
	),

	awful.key({ SUPER, SHIFT }, 'j',
		function ()
			awful.client.swap.byidx(1)
		end,
		{
			description = "Swap Left",
			group = "client"
		}
	),

	awful.key({ SUPER, SHIFT }, 'k',
		function ()
			awful.client.swap.byidx(1)
		end,
		{
			description = "Swap Right",
			group = "client"
		}
	),

	awful.key({ SUPER, SHIFT }, 'l',
		function ()
			awful.client.swap.byidx(-1)
		end,
		{
			description = "Swap Down",
			group = "client"
		}
	)
)

-----------------
-- Tag Management
-----------------
for i = 1, 8 do
    keys.global = gears.table.join(keys.global,
        -- View tag only.
        awful.key({ SUPER }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "Switch to Tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ SUPER, CTRL }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "Toggle View Tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ SUPER, SHIFT }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "Move Client to Tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ SUPER, CTRL, SHIFT }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "Toggle View Client on Tag #" .. i, group = "tag"})
    )
end

keys.global = gears.table.join(keys.global,
	awful.key({ SUPER }, "#" .. 9 + 9,
		function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[9]
			if tag then
				tag:view_only()
			end
		end,
		{
			description = "Switch to the status Tag",
			group = "tag"
		}
	)
)

keys.client = gears.table.join(keys.client,
	awful.key({ SUPER, SHIFT }, "q",
		function (c)
			c:kill()
		end,
		{
			description = "Close the current Client",
			group = "client"
		}
	),
	awful.key({ SUPER, SHIFT, CTRL }, "q",
		function (c)
			awful.util.spawn("kill -9 " .. c.pid)
		end,
		{
			description = "SIGKILL the current Client",
			group = "client"
		}
	)
)

root.keys(keys.global)

return keys
