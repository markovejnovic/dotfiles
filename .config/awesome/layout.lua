local awful = require('awful')

local last_layout = awful.layout.get()

layout = {
	toggle_max = function ()
		local cl = awful.layout.get()

		if awful.layout.suit.max == cl then
			awful.layout.set(last_layout)
		else
			last_layout = cl
			awful.layout.set(awful.layout.suit.max)
		end
	end,

	toggle_tiling = function ()
		local cl = awful.layout.get()

		if awful.layout.suit.fair == cl then
			awful.layout.set(last_layout)
		else
			last_layout = cl
			awful.layout.set(awful.layout.suit.fair)
		end
	end
}

return layout
