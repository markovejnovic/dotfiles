local gears = require("gears")
local wibox = require("wibox")
local theme = require('themes.terrible.theme')

local temperature_bar = wibox.widget{
    widget = wibox.widget.textbox,
    font = theme.font,
    text = 'CPUTEMP N/A '
}

awesome.connect_signal("wiful::temperature", function(value)
    temperature_bar.text = 'CPUT: ' .. value .. 'C '
end)

return temperature_bar
