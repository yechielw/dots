hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 1,
		["col.active_border"] = "rgb(42A5F5)",
		["col.inactive_border"] = "rgb(45475a)",
	},
})

hl.config({
	decoration = {
		rounding = 12,
		blur = {
			enabled = true,
			size = 10,
			passes = 3,
			new_optimizations = true,
			xray = true,
		},
	},
})

-- Window rules for floating windows
hl.window_rule({ match = { float = true }, border_size = 1 })
hl.window_rule({ match = { float = true }, rounding = 18 })
hl.window_rule({ match = { float = true }, border_color = "rgb(7f849c) rgb(7f849c)" })

-- ~/.config/hypr/macos27-look.lua
-- require("macos27-look") from ~/.config/hypr/hyprland.lua

hl.config({
	general = {
		float_gaps = 12,

		border_size = 1,
		resize_on_border = true,
		extend_border_grab_area = 18,

		col = {
			-- subtle glass edge: bright upper edge + darker lower edge
			active_border = {
				colors = { "rgba(ffffff55)", "rgba(00000022)" },
				angle = 145,
			},
			inactive_border = {
				colors = { "rgba(ffffff24)", "rgba(00000014)" },
				angle = 145,
			},
		},
	},

	decoration = {
		-- macOS 27 / Golden Gate: tighter than Tahoe, still rounded.
		-- rounding_power=4 gives a squircle/continuous-corner feel.
		rounding = 14,
		rounding_power = 4.0,
		border_part_of_window = true,

		-- Keep nearly opaque. More transparent than this makes browsers/editors look wrong.
		active_opacity = 0.985,
		inactive_opacity = 0.965,
		fullscreen_opacity = 1.0,

		dim_inactive = true,
		dim_strength = 0.035,

		blur = {
			enabled = true,
			size = 10,
			passes = 3,
			ignore_opacity = true,
			new_optimizations = true,
			xray = true,

			noise = 0.018,
			contrast = 1.04,
			brightness = 1.04,
			vibrancy = 0.18,
			vibrancy_darkness = 0.08,

			popups = true,
			popups_ignorealpha = 0.55,
			input_methods = true,
			input_methods_ignorealpha = 0.55,
		},

		shadow = {
			enabled = true,

			-- macOS-like: large, soft, mostly downward.
			range = 42,
			render_power = 2,
			sharp = false,
			color = "rgba(00000055)",
			color_inactive = "rgba(0000002b)",
			offset = { 0, 14 },
			scale = 0.97,
		},

		-- fake specular/inner highlight
		glow = {
			enabled = true,
			range = 2,
			render_power = 1,
			color = "rgba(ffffff1f)",
			color_inactive = "rgba(ffffff10)",
		},
	},
})

-- Apple-ish motion: fast, springy, not bouncy.
-- Hyprland animation speed is deciseconds: 2.2 ~= 220ms.
hl.curve("macosEase", {
	type = "bezier",
	points = { { 0.20, 0.80 }, { 0.20, 1.00 } },
})

hl.curve("macosSpring", {
	type = "spring",
	mass = 1,
	stiffness = 260,
	dampening = 32,
})

hl.animation({ leaf = "windows", enabled = true, speed = 2.2, spring = "macosSpring", style = "popin 96%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.8, spring = "macosSpring" })
hl.animation({ leaf = "layers", enabled = true, speed = 2.0, bezier = "macosEase", style = "fade" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.8, bezier = "macosEase" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 2.4, bezier = "macosEase" })
hl.animation({ leaf = "border", enabled = true, speed = 2.0, bezier = "macosEase" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, spring = "macosSpring", style = "slidefade 18%" })

-- Floating/dialog windows get the full macOS-like treatment.
hl.window_rule({
	match = { float = true },
	rounding = 14,
	rounding_power = 4.0,
	border_size = 1,
	animation = "popin 96%",
})

hl.window_rule({
	match = { modal = true },
	dim_around = true,
	animation = "popin 94%",
})

-- Fullscreen should look like real fullscreen, not a rounded glass card.
hl.window_rule({
	match = { fullscreen = true },
	rounding = 0,
	border_size = 0,
	no_shadow = true,
	no_blur = true,
	opacity = "1.0 override 1.0 override 1.0 override",
})

-- Keep dense/content apps opaque;
-- global translucency looks bad on browsers/videos.
hl.window_rule({
	match = {
		class = "(firefox|zen|chromium|Google-chrome|Brave-browser|code|Code|mpv|vlc|steam|Spotify)",
	},
	opacity = "1.0 override 1.0 override 1.0 override",
	no_blur = true,
})

-- Glassy layers: bars, launchers, notification centers.
hl.layer_rule({
	match = { namespace = "waybar" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.55,
	xray = true,
})
hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.55,
	xray = true,
})
hl.layer_rule({
	match = { namespace = "wofi" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.55,
	xray = true,
})
hl.layer_rule({
	match = { namespace = "walker" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.55,
	xray = true,
})
hl.layer_rule({
	match = { namespace = "vicinae.*" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.55,
	xray = true,
})
hl.layer_rule({
	match = { namespace = "swaync.*" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.55,
	xray = true,
})
hl.layer_rule({
	match = { namespace = "notifications" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.55,
	xray = true,
})
hl.layer_rule({
	match = { namespace = "quickshell.*" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.55,
	xray = true,
})
