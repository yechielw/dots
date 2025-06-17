{ pkgs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "desc:InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x854B,1920x1200@60.0,3840x120,1.25"
      "desc:Lenovo Group Limited E24-28 VVQ36240,1920x1080@60.0,0x0,1.0"
      "desc:Lenovo Group Limited E24-28 VVQ36235,1920x1080@60.0,1920x0,1.0"
    ];

    "$terminal" = ''
      sh -c '[ -n "$(hyprctl clients | grep  ghostty)" ] && hyprctl dispatch focuswindow class:com.mitchellh.ghostty || ghostty'
    '';
    "$fileManager" = "nautilus";
    "$menu" = "walker";

    "$mod" = "SUPER";

    bind =
      [
        "$mod, F, exec, firefox"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );
  };
}
