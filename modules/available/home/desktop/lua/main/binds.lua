hl.bind("SUPER + O", hl.dsp.exec_cmd("ocr"))
hl.bind("SUPER + return", hl.dsp.exec_cmd("raise -c com.mitchellh.ghostty -e ghostty"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("raise -c google-chrome -e google-chrome-stable"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("raise -c chromium-browser -e chromium"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("raise -c microsoft-edge -e microsoft-edge"))
hl.bind(
	"SUPER + W",
	hl.dsp.exec_cmd(
		[[hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1, disabled = false })'; hyprctl reload]]
	)
)
hl.bind("SUPER + Z", hl.dsp.exec_cmd("raise -c zen -e zen"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("raise -e 'burpsuite & chromium' -c burp-StartBurp"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + C", hl.dsp.exit())
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
-- hl.bind("SUPER + V", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
-- hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("vicinae core/search-emojis"))
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind("SUPER + space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + P", hl.dsp.window.pseudo({ action = "toggle" }))
-- hl.bind("SUPER + code:3f", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = true }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("Print", hl.dsp.exec_cmd("flameshot gui"))
-- hl.bind("SUPER + Escape", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + T", hl.dsp.send_shortcut({ mods = "CTRL", key = "T", window = "Burp" }))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("vicinae://launch/wm/switch-windows"))

hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + h", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "d" }))

hl.bind("SUPER + ALT + right", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind("SUPER + ALT + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind("SUPER + ALT + h", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind("SUPER + ALT + l", hl.dsp.workspace.move({ monitor = "r" }))

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1", follow = true }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2", follow = true }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3", follow = true }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4", follow = true }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5", follow = true }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6", follow = true }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7", follow = true }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8", follow = true }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9", follow = true }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10", follow = true }))

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true, locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
