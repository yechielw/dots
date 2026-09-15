hl.layer_rule({
	name = "waybar-blur-effects",
	match = { namespace = "waybar" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.2,
})
-- hl.layer_rule({
-- 	name = "vicinae-overlay-effects",
-- 	match = { namespace = "vicinae" },
-- 	blur = true,
-- 	ignore_alpha = 0,
-- 	no_anim = true,
-- })

hl.window_rule({
	name = "microsoft-xwayland-float",
	match = { class = "Microsoft", xwayland = true },
	float = true,
})
hl.window_rule({ name = "backslash-float", match = { class = "backslash" }, float = true })
hl.window_rule({ name = "gradia-float", match = { class = "be.alexandervanhee.gradia" }, float = true })
hl.window_rule({ name = "blueman-float", match = { class = "blueman" }, float = true })
hl.window_rule({
	name = "flameshot-class-capture-overlay",
	match = { class = "flameshot" },
	float = true,
	monitor = "1",
	move = { 0, 0 },
	no_anim = true,
	pin = true,
})
hl.window_rule({
	name = "flameshot-title-capture-overlay",
	match = { title = "flameshot" },
	float = true,
	monitor = "1",
	move = { 0, 0 },
	no_anim = true,
	pin = true,
	suppress_event = "fullscreen",
})
hl.window_rule({ name = "nwg-displays-float", match = { class = "nwg-displays" }, float = true })
hl.window_rule({
	name = "nautilus-previewer-overlay",
	match = { class = "org.gnome.NautilusPreviewer" },
	float = true,
	size = { "80%", "80%" },
})
hl.window_rule({
	name = "chrome-untitled-window-float",
	match = { initial_title = "Untitled - Google Chrome" },
	float = true,
})
hl.window_rule({
	name = "ulauncher-overlay",
	match = { class = "ulauncher" },
	no_anim = true,
	no_blur = true,
	border_size = 0,
	no_shadow = true,
	stay_focused = true,
})
hl.window_rule({
	name = "empty-xwayland-window-no-focus",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
hl.window_rule({ name = "gcr-access-prompt-pin", match = { class = "gcr-prompter" }, pin = true })
hl.window_rule({ name = "kupfer-stay-focused", match = { title = ".*kupfer.*" }, stay_focused = true })
hl.window_rule({ name = "all-windows-suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
	name = "ghostty-workspace-1",
	match = { class = "com.mitchellh.ghostty" },
	workspace = "1",
})
hl.window_rule({ name = "kitty-workspace-1", match = { class = "kitty" }, workspace = "1" })
hl.window_rule({ name = "google-chrome-workspace-2", match = { class = "google-chrome" }, workspace = "2" })
hl.window_rule({ name = "microsoft-edge-workspace-5", match = { class = "microsoft-edge" }, workspace = "5" })
hl.window_rule({ name = "burp-suite-workspace-4", match = { class = "burp-StartBurp" }, workspace = "4" })
hl.window_rule({
	name = "citrix-session-manager-float-bottom-right",
	match = { class = "Icasessionmgr" },
	float = true,
	move = { "monitor_w-window_w", "monitor_h-window_h-40" },
})
hl.window_rule({
	name = "citrix-session-window-workspace-and-focus",
	match = { class = "Wfica.*" },
	workspace = "8",
	no_initial_focus = true,
})
hl.window_rule({
	name = "burp-filter-dialog-float",
	match = { class = "burp-StartBurp", title = ".*bfilter$" },
	float = true,
})
