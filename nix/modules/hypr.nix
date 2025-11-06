{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.hm.hypr = {
    enable = lib.mkEnableOption "hypr";
  };
  config = lib.mkIf config.hm.hypr.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # plugins = [
      #   # pkgs.hyprlandPlugins.hyprexpo
      # pkgs.hyprlandPlugins.hyprgrass
      # # pkgs.hyprlandPlugins.hyprspace
      # ];
      settings = {
        # monitor = [
        #   "eDP-1,1920x1200@60.0,3840x120,1.0"
        #   "DP-6,1920x1080@60.0,0x0,1.0"
        #   "DP-7,1920x1080@60.0,1920x0,1.0"
        # ];
        source = "monitors.conf";
        env = [
          "XCURSOR_SIZE,24"
          "XCURSOR_THEME,BreezeX-RosePine-Linux"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,rose-pine-hyprcursor"
          "_JAVA_AWT_WM_NONEREPARENTING,1"
          "_JAVA_OPTIONS,-Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.opengl=true -Dsun.java2d.noddraw=true -Dsun.java2d.d3d=false -Dswing.useflipBufferStrategy=True -Dsun.java2d.ddforcevram=true -Dsun.java2d.ddblit=false"
        ];
        general = {
          gaps_in = 0;
          gaps_out = 1;
          border_size = 1;
          "col.active_border" = "rgba(bbbbbb66)";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = true;
          allow_tearing = false;
          layout = "dwindle";
        };
        decoration = {
          rounding = 7;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          dim_inactive = true;
          dim_strength = 0.03;
          shadow = {
            range = 20;
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 0, 6, default"
          ];
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        master = {
          new_status = "master";
        };
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          focus_on_activate = true;
        };
        input = {
          kb_layout = "us,il";
          kb_variant = "";
          kb_options = "grp:alt_shift_toggle,grp:caps_toggle";
          follow_mouse = 1;
          sensitivity = 0;
          #accel_profile = "custom 0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
          #scroll_points = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
          touchpad = {
            natural_scroll = false;
          };
        };
        gestures = {
          workspace_swipe_touch = true;
        };
        gesture = "3, horizontal, workspace";

        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
          ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ];
        xwayland = {
          force_zero_scaling = true;
        };
        workspace = [
          "1,monitor:DP-6,default:true"
          "4,monitor:DP-6"
          "7,monitor:DP-6"

          "2,monitor:DP-7,default:true"
          "5,monitor:DP-7"
          "8,monitor:DP-7"

          "3,monitor:eDP-1,default:true"
          "6,monitor:eDP-1"
          "9,monitor:eDP-1"
        ];
        bind = [
          # "SUPER, return, exec, raise -c kitty -e kitty"
          "SUPER, O, exec, ${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\" - | ${lib.getExe pkgs.tesseract} - - | ${pkgs.wl-clipboard}/bin/wl-copy"
          "SUPER, return, exec, raise -c com.mitchellh.ghostty -e ghostty"
          "SUPER, A, exec,  raise -c google-chrome -e google-chrome-stable"
          "SUPER, M, exec,  raise -c microsoft-edge -e microsoft-edge"
          "SUPER, Z, exec,  raise -c zen -e zen"
          "SUPER, B, exec,  raise -e burpsuite -c burp-StartBurp"
          "SUPER, Q, killactive,"
          "SUPER shift, C, exit,"
          "SUPER, E, exec, nautilus"
          "SUPER, V, exec, xdg-open vicinae://extensions/vicinae/clipboard/history"
          "SUPER, PERIOD, exec, xdg-open vicinae://extensions/vicinae/vicinae/search-emojis"
          # "ALT, TAB, exec, xdg-open vicinae://extensions/vicinae/wm/switch-windows"
          "SUPER, F, togglefloating,"
          "SUPER, space, exec, vicinae toggle"
          "SUPER, P, pseudo, "
          "SUPER, ?, togglesplit, "
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"
          "SUPER SHIFT, left, movewindow, l"
          "SUPER SHIFT, right, movewindow, r"
          "SUPER SHIFT, up, movewindow, u"
          "SUPER SHIFT, down, movewindow, d"
          "SUPER, h, movefocus, l"
          "SUPER, j, movefocus, r"
          "SUPER, k, movefocus, u"
          "SUPER, l, movefocus, d"
          "SUPER SHIFT, h, movewindow, l"
          "SUPER SHIFT, j, movewindow, r"
          "SUPER SHIFT, k, movewindow, u"
          "SUPER SHIFT, l, movewindow, d"
          "SUPER ALT, right, movecurrentworkspacetomonitor, r"
          "SUPER ALT, left, movecurrentworkspacetomonitor, l"
          "SUPER ALT, h, movecurrentworkspacetomonitor, r"
          "SUPER ALT, j, movecurrentworkspacetomonitor, l"

          # "SUPER, 1, workspace, 1"
          # "SUPER, 2, workspace, 2"
          # "SUPER, 3, workspace, 3"
          # "SUPER, 4, workspace, 4"
          # "SUPER, 5, workspace, 5"
          # "SUPER, 6, workspace, 6"
          # "SUPER, 7, workspace, 7"
          # "SUPER, 8, workspace, 8"
          # "SUPER, 9, workspace, 9"
          # "SUPER, 0, workspace, 10"
          #
          # "SUPER SHIFT, 1, movetoworkspace, 1"
          # "SUPER SHIFT, 2, movetoworkspace, 2"
          # "SUPER SHIFT, 3, movetoworkspace, 3"
          # "SUPER SHIFT, 4, movetoworkspace, 4"
          # "SUPER SHIFT, 5, movetoworkspace, 5"
          # "SUPER SHIFT, 6, movetoworkspace, 6"
          # "SUPER SHIFT, 7, movetoworkspace, 7"
          # "SUPER SHIFT, 8, movetoworkspace, 8"
          # "SUPER SHIFT, 9, movetoworkspace, 9"
          # "SUPER SHIFT, 0, movetoworkspace, 10"

          "SUPER, S, togglespecialworkspace, magic"
          "SUPER SHIFT, S, movetoworkspace, special:magic"
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"
          ", Print, exec, flameshot gui"
          "SUPER, Escape, exec, wlogout"
          "SUPER, T, sendshortcut, CTRL, T, Burp"
        ]
        ++ builtins.concatLists (
          builtins.genList (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "SUPER, ${ws}, workspace, ${toString (x + 1)}"
              "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          ) 10
        );

        layerrule = [
          "blur, waybar"
          "blurpopups, waybar"
          "ignorealpha 0.2, waybar"

          "blur,vicinae"
          "ignorealpha 0, vicinae"
          "noanim, vicinae"
        ];
        windowrulev2 = [
          "float, class:Microsoft, xwayland:1"
          # "float, class:copyq"
          "bordercolor rgba(32CD32AA) rgba(7CFC0077),floating:1"
          "float, class:backslash"
          "float, class:be.alexandervanhee.gradia"
          "float, class:blueman"
          "float, class:flameshot"
          "float, title:flameshot"
          "float, class:nwg-displays"
          "float, class:org.gnome.NautilusPreviewer"
          "float, initialTitle:Untitled - Google Chrome"
          "monitor 1, class:flameshot"
          "monitor 1, title:flameshot"
          "move 0 0, class:flameshot"
          "move 0 0, title:flameshot"
          # "move onscreen cursor 1 1, class:copyq"
          # "noanim, class:copyq"
          "noanim, class:flameshot"
          "noanim, title:flameshot"
          "noanim, class:ulauncher"
          "noblur, class:ulauncher"
          "noborder, class:ulauncher"
          "nofocus ,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          "noshadow, class:ulauncher"
          "pin, class:flameshot"
          "pin, title:flameshot"
          "size 80% 80%, class:org.gnome.NautilusPreviewer"
          "stayfocused, class:ulauncher"
          "stayfocused, title:.*kupfer.*"
          "suppressevent fullscreen,title:flameshot"
          "suppressevent maximize, class:.*"
          "workspace 1, class:com.mitchellh.ghostty"
          "workspace 1, class:kitty"
          "workspace 2, class:google-chrome"
          "workspace 5, class:microsoft-edge"
          "workspaces 4, class:burp-StartBurp"
          "workspaces 8, class:Icasessionmgr"
          "workspaces 8, class:Wfica.*"
          "float, class:burp-StartBurp, title:.*\bfilter$"
          "stayfocused, class:burp-StartBurp, floating:1"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];
      };
      extraConfig = ''
        # bind = SUPER, R, submap, resize
        #
        # submap = resize
        #
        # binde = , right, resizeactive, 10 0
        # binde = , left, resizeactive, -10 0
        # binde = , up, resizeactive, 0 -10
        # binde = , down, resizeactive, 0 10
        #
        # binde = , h, resizeactive, 10 0
        # binde = , j, resizeactive, -10 0
        # binde = , k, resizeactive, 0 -10
        # binde = , l, resizeactive, 0 10
        #  
        # bind = , escape, submap, reset
        #  
        # submap = reset";
      '';
    };
  };
}
