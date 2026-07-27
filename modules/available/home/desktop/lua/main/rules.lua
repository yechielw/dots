hl.layer_rule({ name = "layer-rule-001", match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ name = "layer-rule-002", match = { namespace = "waybar" }, blur_popups = true })
hl.layer_rule({ name = "layer-rule-003", match = { namespace = "waybar" }, ignore_alpha = 0.2 })
-- hl.layer_rule({ name = "layer-rule-004", match = { namespace = "vicinae" }, blur = true })
-- hl.layer_rule({ name = "layer-rule-005", match = { namespace = "vicinae" }, ignore_alpha = 0 })
-- hl.layer_rule({ name = "layer-rule-006", match = { namespace = "vicinae" }, no_anim = true })

hl.window_rule({
	name = "window-rule-001",
	match = { class = "Microsoft", xwayland = true },
	float = true,
})
hl.window_rule({ name = "window-rule-002", match = { class = "backslash" }, float = true })
hl.window_rule({ name = "window-rule-003", match = { class = "be.alexandervanhee.gradia" }, float = true })
hl.window_rule({ name = "window-rule-004", match = { class = "blueman" }, float = true })
hl.window_rule({ name = "window-rule-005", match = { class = "flameshot" }, float = true })
hl.window_rule({ name = "window-rule-006", match = { title = "flameshot" }, float = true })
hl.window_rule({ name = "window-rule-007", match = { class = "nwg-displays" }, float = true })
hl.window_rule({
	name = "window-rule-008",
	match = { class = "org.gnome.NautilusPreviewer" },
	float = true,
})
hl.window_rule({
	name = "window-rule-009",
	match = { initial_title = "Untitled - Google Chrome" },
	float = true,
})
hl.window_rule({ name = "window-rule-010", match = { class = "flameshot" }, monitor = "1" })
hl.window_rule({ name = "window-rule-011", match = { title = "flameshot" }, monitor = "1" })
hl.window_rule({ name = "window-rule-012", match = { class = "flameshot" }, move = { 0, 0 } })
hl.window_rule({ name = "window-rule-013", match = { title = "flameshot" }, move = { 0, 0 } })
hl.window_rule({ name = "window-rule-014", match = { class = "flameshot" }, no_anim = true })
hl.window_rule({ name = "window-rule-015", match = { title = "flameshot" }, no_anim = true })
hl.window_rule({ name = "window-rule-016", match = { class = "ulauncher" }, no_anim = true })
hl.window_rule({ name = "window-rule-017", match = { class = "ulauncher" }, no_blur = true })
hl.window_rule({ name = "window-rule-018", match = { class = "ulauncher" }, border_size = 0 })
hl.window_rule({
	name = "window-rule-019",
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
hl.window_rule({ name = "window-rule-020", match = { class = "ulauncher" }, no_shadow = true })
hl.window_rule({ name = "window-rule-021", match = { class = "flameshot" }, pin = true })
hl.window_rule({ name = "window-rule-022", match = { title = "flameshot" }, pin = true })
hl.window_rule({ name = "window-rule-023", match = { class = "gcr-prompter" }, pin = true })
hl.window_rule({
	name = "window-rule-024",
	match = { class = "org.gnome.NautilusPreviewer" },
	size = { "80%", "80%" },
})
hl.window_rule({ name = "window-rule-025", match = { class = "ulauncher" }, stay_focused = true })
hl.window_rule({ name = "window-rule-026", match = { title = ".*kupfer.*" }, stay_focused = true })
hl.window_rule({
	name = "window-rule-027",
	match = { title = "flameshot" },
	suppress_event = "fullscreen",
})
hl.window_rule({ name = "window-rule-028", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
	name = "window-rule-029",
	match = { class = "com.mitchellh.ghostty" },
	workspace = "1",
})
hl.window_rule({ name = "window-rule-030", match = { class = "kitty" }, workspace = "1" })
hl.window_rule({ name = "window-rule-031", match = { class = "google-chrome" }, workspace = "2" })
hl.window_rule({ name = "window-rule-032", match = { class = "microsoft-edge" }, workspace = "5" })
hl.window_rule({ name = "window-rule-033", match = { class = "burp-StartBurp" }, workspace = "4" })
hl.window_rule({ name = "window-rule-034", match = { class = "Icasessionmgr" }, workspace = "8" })
hl.window_rule({ name = "window-rule-035", match = { class = "Wfica.*" }, workspace = "8" })
hl.window_rule({
	name = "window-rule-036",
	match = { class = "Wfica.*" },
	no_initial_focus = true,
})
hl.window_rule({
	name = "window-rule-037",
	match = { class = "burp-StartBurp", title = ".*bfilter$" },
	float = true,
})
