hl.layer_rule({ name = "waybar-blur", match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ name = "waybar-blur-popups", match = { namespace = "waybar" }, blur_popups = true })
hl.layer_rule({ name = "waybar-ignore-transparent-blur", match = { namespace = "waybar" }, ignore_alpha = 0.2 })
-- hl.layer_rule({ name = "vicinae-blur", match = { namespace = "vicinae" }, blur = true })
-- hl.layer_rule({ name = "vicinae-blur-all-alpha", match = { namespace = "vicinae" }, ignore_alpha = 0 })
-- hl.layer_rule({ name = "vicinae-no-animation", match = { namespace = "vicinae" }, no_anim = true })

hl.window_rule({
	name = "microsoft-xwayland-float",
	match = { class = "Microsoft", xwayland = true },
	float = true,
})
hl.window_rule({ name = "backslash-float", match = { class = "backslash" }, float = true })
hl.window_rule({ name = "gradia-float", match = { class = "be.alexandervanhee.gradia" }, float = true })
hl.window_rule({ name = "blueman-float", match = { class = "blueman" }, float = true })
hl.window_rule({ name = "flameshot-class-float", match = { class = "flameshot" }, float = true })
hl.window_rule({ name = "flameshot-title-float", match = { title = "flameshot" }, float = true })
hl.window_rule({ name = "nwg-displays-float", match = { class = "nwg-displays" }, float = true })
hl.window_rule({
	name = "nautilus-previewer-float",
	match = { class = "org.gnome.NautilusPreviewer" },
	float = true,
})
hl.window_rule({
	name = "chrome-untitled-window-float",
	match = { initial_title = "Untitled - Google Chrome" },
	float = true,
})
hl.window_rule({ name = "flameshot-class-monitor-1", match = { class = "flameshot" }, monitor = "1" })
hl.window_rule({ name = "flameshot-title-monitor-1", match = { title = "flameshot" }, monitor = "1" })
hl.window_rule({ name = "flameshot-class-move-to-origin", match = { class = "flameshot" }, move = { 0, 0 } })
hl.window_rule({ name = "flameshot-title-move-to-origin", match = { title = "flameshot" }, move = { 0, 0 } })
hl.window_rule({ name = "flameshot-class-no-animation", match = { class = "flameshot" }, no_anim = true })
hl.window_rule({ name = "flameshot-title-no-animation", match = { title = "flameshot" }, no_anim = true })
hl.window_rule({ name = "ulauncher-no-animation", match = { class = "ulauncher" }, no_anim = true })
hl.window_rule({ name = "ulauncher-no-blur", match = { class = "ulauncher" }, no_blur = true })
hl.window_rule({ name = "ulauncher-no-border", match = { class = "ulauncher" }, border_size = 0 })
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
hl.window_rule({ name = "ulauncher-no-shadow", match = { class = "ulauncher" }, no_shadow = true })
hl.window_rule({ name = "flameshot-class-pin", match = { class = "flameshot" }, pin = true })
hl.window_rule({ name = "flameshot-title-pin", match = { title = "flameshot" }, pin = true })
hl.window_rule({ name = "gcr-access-prompt-pin", match = { class = "gcr-prompter" }, pin = true })
hl.window_rule({
	name = "nautilus-previewer-size-80-percent",
	match = { class = "org.gnome.NautilusPreviewer" },
	size = { "80%", "80%" },
})
hl.window_rule({ name = "ulauncher-stay-focused", match = { class = "ulauncher" }, stay_focused = true })
hl.window_rule({ name = "kupfer-stay-focused", match = { title = ".*kupfer.*" }, stay_focused = true })
hl.window_rule({
	name = "flameshot-suppress-fullscreen",
	match = { title = "flameshot" },
	suppress_event = "fullscreen",
})
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
hl.window_rule({ name = "citrix-session-window-workspace-8", match = { class = "Wfica.*" }, workspace = "8" })
hl.window_rule({
	name = "citrix-session-window-no-initial-focus",
	match = { class = "Wfica.*" },
	no_initial_focus = true,
})
hl.window_rule({
	name = "burp-filter-dialog-float",
	match = { class = "burp-StartBurp", title = ".*bfilter$" },
	float = true,
})
