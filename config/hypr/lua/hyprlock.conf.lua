-- Source: hyprlock.conf
-- Refactored by hand to use Lua tables and loops.

hl.config({
	auth = {
		["fingerprint:enabled"] = true,
	},
	background = {
		blur_passes = 3,
		blur_size = 8,
		path = "/home/yechiel/Pictures/Sruly.jpg",
	},
	general = {
		disable_loading_bar = true,
		grace = 5,
		hide_cursor = true,
		no_fade_in = false,
	},
	["input-field"] = {
		monitor = "",
		size = "200, 50",
		capslock_color = "rgb (120, 91, 113)",
		dots_center = true,
		fade_on_empty = false,
		font_color = "rgb(202, 211, 245)",
		inner_color = "rgb(91, 96, 120)",
		outer_color = "rgb(24, 25, 38)",
		outline_thickness = 0,
		placeholder_text = [[<span foreground="##cad3f5">Enter Password</span>]],
		position = "0, -40%",
		shadow_passes = 2,
	},
})

local labels = {
	{
		monitor = "",
		color = "rgba(200, 200, 200, 1.0)",
		font_size = 10,
		halign = "center",
		position = "0, -45%",
		text = "$LAYOUT",
		valign = "center",
	},
	{
		monitor = "",
		color = "rgba(255, 255, 255, 1.0)",
		font_size = 14,
		halign = "center",
		position = "0, -30%",
		text = "cmd[update:1000] echo $(cat /sys/class/power_supply/BAT0/capacity)%",
		valign = "center",
	},
}

for _, label in ipairs(labels) do
	hl.config({ label = label })
end
