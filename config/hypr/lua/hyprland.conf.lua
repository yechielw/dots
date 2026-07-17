-- Source: hyprland.conf
-- Refactored by hand to use Lua tables and loops.

local main_mod = "SUPER + "

local commands = {
	ocr_screenshot = "ocr",
	terminal = "raise -c com.mitchellh.ghostty -e ghostty",
	chrome = "raise -c google-chrome -e google-chrome-stable",
	chromium_burp = "raise -c chromium-browser -e chromium",
	edge = "raise -c microsoft-edge -e microsoft-edge",
	zen = "raise -c zen -e zen",
	burp = "raise -e 'burpsuite & chromium' -c burp-StartBurp",
	file_manager = "nautilus",
	clipboard = "vicinae vicinae://launch/clipboard/history",
	emoji = "vicinae core/search-emojis",
	launcher = "vicinae toggle",
	window_switcher = "vicinae://launch/wm/switch-windows",
	screenshot = "flameshot gui",
	edpfix = [[hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1, disabled = false })'; hyprctl reload]]
}

local env = {
	QT_QPA_PLATFORMTHEME = "gnome",
	XCURSOR_SIZE = "24",
	XCURSOR_THEME = "BreezeX-RosePine-Linux",
	HYPRCURSOR_SIZE = "24",
	HYPRCURSOR_THEME = "rose-pine-hyprcursor",
	_JAVA_AWT_WM_NONEREPARENTING = "1",
	_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.opengl=true -Dsun.java2d.noddraw=true -Dsun.java2d.d3d=false -Dswing.useflipBufferStrategy=True -Dsun.java2d.ddforcevram=true -Dsun.java2d.ddblit=false",
}

for name, value in pairs(env) do
	hl.env(name, value)
end

hl.on("hyprland.start", function()
	hl.exec_cmd(commands.startup)
end)

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

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

local animations = {
	{ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" },
	{ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" },
	{ leaf = "border", enabled = true, speed = 10, bezier = "default" },
	{ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" },
	{ leaf = "fade", enabled = true, speed = 7, bezier = "default" },
	{ leaf = "workspaces", enabled = false, speed = 6, bezier = "default" },
}

for _, animation in ipairs(animations) do
	hl.animation(animation)
end

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

local function bind(key, dispatcher, options)
	hl.bind(key, dispatcher, options)
end

local function exec(command)
	return hl.dsp.exec_cmd(command)
end

local simple_binds = {
	{ main_mod .. "O", exec(commands.ocr_screenshot) },
	{ main_mod .. "return", exec(commands.terminal) },
	{ main_mod .. "A", exec(commands.chrome) },
	{ main_mod .. "C", exec(commands.chromium_burp) },
	{ main_mod .. "M", exec(commands.edge) },
	{ main_mod .. "W", exec(commands.edpfix) },
	{ main_mod .. "Z", exec(commands.zen) },
	{ main_mod .. "B", exec(commands.burp) },
	{ main_mod .. "Q", hl.dsp.window.close() },
	{ main_mod .. "SHIFT + C", hl.dsp.exit() },
	{ main_mod .. "E", exec(commands.file_manager) },
	{ main_mod .. "V", exec(commands.clipboard) },
	{ main_mod .. "PERIOD", exec(commands.emoji) },
	{ main_mod .. "F", hl.dsp.window.float({ action = "toggle" }) },
	{ main_mod .. "space", exec(commands.launcher) },
	{ main_mod .. "P", hl.dsp.window.pseudo({ action = "toggle" }) },
	-- { main_mod .. "code:3f", hl.dsp.layout("togglesplit") },
	{ main_mod .. "S", hl.dsp.workspace.toggle_special("magic") },
	{ main_mod .. "SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = true }) },
	{ main_mod .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }) },
	{ main_mod .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }) },
	{ "Print", exec(commands.screenshot) },
	{ main_mod .. "Escape", exec("dms ipc call lock lock") },
	{ main_mod .. "T", hl.dsp.send_shortcut({ mods = "CTRL", key = "T", window = "Burp" }) },
	{ main_mod .. "TAB", exec(commands.window_switcher) },
}

for _, item in ipairs(simple_binds) do
	bind(item[1], item[2], item[3])
end

local focus_keys = {
	left = "l",
	right = "r",
	up = "u",
	down = "d",
	h = "l",
	j = "r",
	k = "u",
	l = "d",
}

for key, direction in pairs(focus_keys) do
	bind(main_mod .. "" .. key, hl.dsp.focus({ direction = direction }))
	bind(main_mod .. "SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

local monitor_move_keys = {
	right = "r",
	left = "l",
	h = "l",
	l = "r",
}

for key, monitor in pairs(monitor_move_keys) do
	bind(main_mod .. "ALT + " .. key, hl.dsp.workspace.move({ monitor = monitor }))
end

for workspace = 1, 10 do
	local key = tostring(workspace % 10)
	local workspace_name = tostring(workspace)

	bind(main_mod .. "" .. key, hl.dsp.focus({ workspace = workspace_name }))
	bind(main_mod .. "SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace_name, follow = true }))
end

local repeating_locked_binds = {
	{ "XF86AudioRaiseVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" },
	{ "XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" },
	{ "XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
	{ "XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" },
	{ "XF86MonBrightnessUp", "brightnessctl set 5%+" },
	{ "XF86MonBrightnessDown", "brightnessctl set 5%-" },
}

for _, item in ipairs(repeating_locked_binds) do
	bind(item[1], exec(item[2]), { repeating = true, locked = true })
end

local locked_media_binds = {
	{ "XF86AudioNext", "playerctl next" },
	{ "XF86AudioPause", "playerctl play-pause" },
	{ "XF86AudioPlay", "playerctl play-pause" },
	{ "XF86AudioPrev", "playerctl previous" },
}

for _, item in ipairs(locked_media_binds) do
	bind(item[1], exec(item[2]), { locked = true })
end

bind(main_mod .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(main_mod .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

local layer_rules = {
	{ namespace = "waybar", blur = true },
	{ namespace = "waybar", blur_popups = true },
	{ namespace = "waybar", ignore_alpha = 0.2 },
	{ namespace = "vicinae", blur = true },
	{ namespace = "vicinae", ignore_alpha = 0 },
	{ namespace = "vicinae", no_anim = true },
}

for index, rule in ipairs(layer_rules) do
	local namespace = rule.namespace
	rule.namespace = nil
	rule.name = string.format("layer-rule-%03d", index)
	rule.match = { namespace = namespace }
	hl.layer_rule(rule)
end

local window_rules = {
	{ match = { class = "Microsoft", xwayland = true }, float = true },
	{ match = { class = "backslash" }, float = true },
	{ match = { class = "be.alexandervanhee.gradia" }, float = true },
	{ match = { class = "blueman" }, float = true },
	{ match = { class = "flameshot" }, float = true },
	{ match = { title = "flameshot" }, float = true },
	{ match = { class = "nwg-displays" }, float = true },
	{ match = { class = "org.gnome.NautilusPreviewer" }, float = true },
	{ match = { initial_title = "Untitled - Google Chrome" }, float = true },
	{ match = { class = "flameshot" }, monitor = "1" },
	{ match = { title = "flameshot" }, monitor = "1" },
	{ match = { class = "flameshot" }, move = { 0, 0 } },
	{ match = { title = "flameshot" }, move = { 0, 0 } },
	{ match = { class = "flameshot" }, no_anim = true },
	{ match = { title = "flameshot" }, no_anim = true },
	{ match = { class = "ulauncher" }, no_anim = true },
	{ match = { class = "ulauncher" }, no_blur = true },
	{ match = { class = "ulauncher" }, border_size = 0 },
	{ match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true },
	{ match = { class = "ulauncher" }, no_shadow = true },
	{ match = { class = "flameshot" }, pin = true },
	{ match = { title = "flameshot" }, pin = true },
	{ match = { class = "gcr-prompter" }, pin = true },
	{ match = { class = "org.gnome.NautilusPreviewer" }, size = { "80%", "80%" } },
	{ match = { class = "ulauncher" }, stay_focused = true },
	{ match = { title = ".*kupfer.*" }, stay_focused = true },
	{ match = { title = "flameshot" }, suppress_event = "fullscreen" },
	{ match = { class = ".*" }, suppress_event = "maximize" },
	{ match = { class = "com.mitchellh.ghostty" }, workspace = "1" },
	{ match = { class = "kitty" }, workspace = "1" },
	{ match = { class = "google-chrome" }, workspace = "2" },
	{ match = { class = "microsoft-edge" }, workspace = "5" },
	{ match = { class = "burp-StartBurp" }, workspace = "4" },
	{ match = { class = "Icasessionmgr" }, workspace = "8" },
	{ match = { class = "Wfica.*" }, workspace = "8" },
	{ match = { class = "Wfica.*" }, no_initial_focus = true },
	{ match = { class = "burp-StartBurp", title = ".*bfilter$" }, float = true },
}

for index, rule in ipairs(window_rules) do
	rule.name = rule.name or string.format("window-rule-%03d", index)
	hl.window_rule(rule)
end

local workspace_monitors = {
	["DP-6"] = {
		default = 1,
		workspaces = { 1, 4, 7 },
	},
	["DP-7"] = {
		default = 2,
		workspaces = { 2, 5, 8 },
	},
	["eDP-1"] = {
		default = 3,
		workspaces = { 3, 6, 9 },
	},
}

for monitor, group in pairs(workspace_monitors) do
	for _, workspace in ipairs(group.workspaces) do
		hl.workspace_rule({
			workspace = tostring(workspace),
			monitor = monitor,
			default = workspace == group.default,
		})
	end
end

require("temp")
