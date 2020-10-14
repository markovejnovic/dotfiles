local wibox = require('wibox')
local gears = require('gears')

local widgets = {
	battery = wibox.widget {
		{
			id = 'awwdgtbatt',
			text = '100%',
			widget = wibox.widget.textbox
		},
		set_battery = function(self, val)
			self.awwdgtbatt.text = val .. '%'
		end
	}
}

gears.timer {
	timeout = 7,
	call_now = true,
	autostart = true,
	callback = function ()
		local bpipe = io.popen('cat /sys/class/power_supply/BAT0/capacity')
		local perc = bpipe:read('*all')
		bpipe:close()

		widgets.battery:set_battery(tonumber(perc))
	end
}

return widgets
