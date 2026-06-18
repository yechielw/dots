-- Source: monitors2.conf
-- Refactored by hand to use Lua tables and loops.

local monitors = {
	{ output = "eDP-1", mode = "1920x1200@60.0", position = "6624x0", scale = "1.0" },
	{ output = "DP-6", mode = "1920x1080@60.0", position = "2784x0", scale = "1.0" },
	{ output = "DP-7", mode = "1920x1080@60.0", position = "4704x0", scale = "1.0" },
	{ output = "DP-1", mode = "1920x1080@60.0", position = "4704x0", scale = "1.0" },
}

for _, monitor in ipairs(monitors) do
	hl.monitor(monitor)
end
