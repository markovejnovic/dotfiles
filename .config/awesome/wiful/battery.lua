local awful = require('awful')
local update_interval = 60

local charger_script = [[
    sh -c '
    acpi_listen | grep --line-buffered ac_adapter
    '
]]

-- First get battery file path
-- If there are multiple, only get the first one
-- TODO support multiple batteries
awful.spawn.easy_async_with_shell("sh -c 'out=\"$(find /sys/class/power_supply/BAT?/capacity)\" && (echo \"$out\" | head -1) || false' ", function (battery_file, _, __, exit_code)
    -- No battery file found
    if not (exit_code == 0) then
        return
    end
    -- Periodically get battery info
    awful.widget.watch("cat "..battery_file, update_interval, function(_, stdout)
        awesome.emit_signal("wiful::battery", tonumber(stdout))
    end)
end)
