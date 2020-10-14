local gears = require("gears")
local awful = require("awful")

local utils = {}

utils.alsa = {
	mute_t = function ()
		awful.spawn.with_shell("amixer set Master toggle")
	end,
	inc_vol = function (delta)
		if delta >= 0 then
			awful.spawn.with_shell(
				"amixer set Master " .. delta .. "+")
		else
			awful.spawn.with_shell(
				"amixer set Master " .. -delta .. "-")
		end
	end
}

utils.lua = {
	-- Henkrik Ilgen
	-- https://stackoverflow.com/questions/6075262/lua-table-tostringtablename-and-table-fromstringstringtable-functions
	serializeTable = function(val, name, skipnewlines, depth)
	    skipnewlines = skipnewlines or false
	    depth = depth or 0

	    local tmp = string.rep(" ", depth)

	    if name then tmp = tmp .. name .. " = " end

	    if type(val) == "table" then
		tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

		for k, v in pairs(val) do
		    tmp =  tmp .. utils.lua.serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
		end

		tmp = tmp .. string.rep(" ", depth) .. "}"
	    elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	    elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	    elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	    else
		tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
	    end

	    return tmp
	end
}

return utils
