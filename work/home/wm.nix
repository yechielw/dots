{
  lib,
  config,
  ...
}:
{

  options = {
    wm.enable = lib.mkEnableOption "enable window manager stuff for home manager";
  };

  config = lib.mkIf config.wm.enable {

    services = {
      swaync.enable = true;
      swayosd = {
        enable = true;
        topMargin = 0.75;
      };

      copyq.enable = true;
      blueman-applet.enable = true;
      flameshot.enable = true;
      polkit-gnome.enable = true;

      trayscale.enable = true;

      hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";
          #splash = false;
          #splash_offset = 2.0;

          preload = [ "/home/yechiel/Downloads/a.jpg" ];

          wallpaper = [
            ",/home/yechiel/Downloads/a.jpg"
          ];
        };
      };

      hypridle = {
        enable = true;

        settings = {
          general = {
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
            lock_cmd = "pidof hyprlock || hyprlock";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprlock";
            }
            {
              timeout = 300;
              on-timeout = "brightnessctl -sd tpacpi::kbd_backlight set 0";
              on-resume = "brightnessctl -rd tpacpi::kbd_backlight";
            }
            {
              timeout = 350;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 1800;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };

    };

    programs.wlogout.enable = true;

    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    programs.hyprlock = {
      enable = true;
      settings = {

        auth = {
          "fingerprint:enabled" = true;
        };
        general = {
          disable_loading_bar = true;
          grace = 5;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            #path = "/run/user/1000/gvfs/google-drive:host=gmail.com,user=yechielworen/0APHyODMOZp4NUk9PVA/1vs1ck5qp3TXDt6WfkJsOeVvRVLBSVl1p";
            path = "/home/yechiel/Pictures/Sruly.jpg";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        label = [
          {
            monitor = "";
            text = "$LAYOUT";
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 10;
            position = "0, -45%";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -40%";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            capslock_color = "rgb (120, 91, 113)";
            outline_thickness = 0;
            placeholder_text = ''<span foreground="##cad3f5">Enter Password</span>'';
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
