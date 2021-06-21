local gears = require("gears")
local wibox = require("wibox")
local theme = require('themes.terrible.theme')

local battery_bar = wibox.widget{
  widget = wibox.widget.textbox,
  font = theme.font,
  text = 'BAT NA'
}

awesome.connect_signal("wiful::battery", function(value)
    battery_bar.text = 'BAT: ' .. value .. '% '
end)

return battery_bar
