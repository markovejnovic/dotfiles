local awful = require("awful")
local gears = require('gears')

local update_interval = 15
local temp_script = [[
  sh -c "
  sensors | grep Package | awk '{print $4}' | cut -c 2-3
  "]]

-- Periodically get temperature info
awful.widget.watch(temp_script, update_interval, function(widget, stdout)
    awesome.emit_signal("wiful::temperature", stdout)
end)
