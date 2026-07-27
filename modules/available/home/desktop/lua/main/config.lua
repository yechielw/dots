hl.config({
	animations = {
		enabled = true,
	},
	decoration = {
		blur = {
			enabled = true,
			passes = 1,
			size = 3,
			vibrancy = 0.169600,
		},
		shadow = {
			range = 20,
		},
		active_opacity = 1.000000,
		dim_inactive = true,
		dim_strength = 0.030000,
		inactive_opacity = 0.970000,
		rounding = 25,
	},
	dwindle = {
		preserve_split = true,
	},
	general = {
		allow_tearing = false,
		border_size = 1,
		col = {
			active_border = "rgb(4B4D54)",
			inactive_border = "rgba(595959aa)",
		},
		gaps_in = 0,
		gaps_out = 1,
		layout = "dwindle",
		resize_on_border = true,
	},
	gestures = {
		workspace_swipe_touch = true,
	},
	input = {
		touchpad = {
			natural_scroll = false,
		},
		follow_mouse = 1,
		kb_layout = "us,il",
		kb_options = "grp:alt_shift_toggle,grp:caps_toggle",
		kb_variant = "",
		sensitivity = 0,
	},
	master = {
		new_status = "master",
	},
	misc = {
		disable_hyprland_logo = true,
		focus_on_activate = true,
		force_default_wallpaper = 0,
	},
	xwayland = {
		force_zero_scaling = true,
	},
})
