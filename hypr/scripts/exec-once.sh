#nwg-panel &
waybar &
nm-applet --indicator&
copyq &
flameshot &
blueman-tray &
blueman-applet &
ulauncher --hide-window&
swayosd-server  &
systemctl --user start hyprpaper &
hypridle &
kdeconnect-indicator &
trayscale --hide-window&
rquickshare&
sh -c '$(nix path-info nixpkgs\#polkit_gnome)/libexec/polkit-gnome-authentication-agent-1'&

