hl.env("QT_QPA_PLATFORMTHEME", "gnome")
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "BreezeX-RosePine-Linux")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("_JAVA_AWT_WM_NONEREPARENTING", "1")
hl.env(
	"_JAVA_OPTIONS",
	"-Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.opengl=true -Dsun.java2d.noddraw=true -Dsun.java2d.d3d=false -Dswing.useflipBufferStrategy=True -Dsun.java2d.ddforcevram=true -Dsun.java2d.ddblit=false"
)

hl.on("hyprland.start", function()
	hl.exec_cmd(nil)
end)
