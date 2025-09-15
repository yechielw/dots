{
  lib,
  pkgs,
  config,
  ...
}:
{

  options = {
    wm.enable = lib.mkEnableOption "enable window manager stuff for home manager";
  };

  config = lib.mkIf config.wm.enable {

    # xdg.portal.configPackages = [
    #   pkgs.xdg-desktop-portal-hyprland
    #   pkgs.xdg-desktop-portal-gtk
    # ];
    services = {
      udiskie.enable = true;
      vicinae.enable = true;
      pasystray = {
        enable = true;
        extraOptions = [
          "--volume-max=150 --no-notify --symbolic-icons"
        ];
      };
      swaync.enable = true;
      swayosd = {
        enable = true;
        topMargin = 0.75;
      };

      copyq.enable = true;
      blueman-applet.enable = true;
      flameshot.enable = true;
      hyprpolkitagent.enable = true;
      #polkit-gnome.enable = true;

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
      settings = {
        mainBar = {
          layer = "bottom";
          position = "top";
          mod = "dock";
          exclusive = true;
          gtk-layer-shell = true;
          margin-bottom = -1;
          ssthrough = false;
          height = 24;
          modules-left = [
            "hyprland/workspaces"
            "wlr/taskbar"
            "hyprland/submap"
          ];
          modules-center = [ ];
          modules-right = [
            "custom/events"
            "hyprland/language"
            "tray"
            "pulseaudio"
            "battery"
            "custom/swaync"
            "clock"
            "custom/wlogout"
          ];
          "hyprland/window" = {
            format = "{title}";
            separate-outputs = true;
          };
          "hyprland/language" = {
            format = "{}";
            format-en = "EN";
            format-he = "HE";
          };
          "hyprland/workspaces" = {
            format = "{icon}";
            icon-size = 16;
            spacing = 10;
            on-scroll-up = "hyprctl dispatch workspace r+1";
            on-scroll-down = "hyprctl dispatch workspace r-1";
            show-special = true;
            workspace-taskbar = {
              enable = true;
              update-active-window = true;
              format = "{icon}";
            };
          };
          "custom/os_button" = {
            format = "";
            on-click = "wofi --show drun -I -W 30%";
            tooltip = false;
          };
          "custom/swaync" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = " 󰅸 ";
              none = "  ";
              dnd-notification = " <span foreground='red'><small><sup>⬤</sup></small></span>";
              dnd-none = "  ";
            };
            "custom/wlogout" = {
              format = "";
              exec = "wlogout";
            };
            "custom/events" = {
              format = "{}";
              tooltip = true;
              interval = 300;
              format-icons = {
                default = "";
              };
              exec = "waybar-khal.py";
              return-type = "json";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "sleep 0.1 && swaync-client -t -sw";
            on-click-right = "sleep 0.1 && swaync-client -d -sw";
            escape = true;
          };
          "wlr/taskbar" = {
            format = "{icon}";
            icon-size = 20;
            spacing = 3;
            on-click-middle = "close";
            tooltip-format = "{title}";
            ignore-list = [ ];
            on-click = "activate";
          };
          tray = {
            icon-size = 18;
            spacing = 3;
          };
          clock = {
            format = "{:%a %e %b %H:%M}";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              on-click-right = "mode";
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 20;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-alt = "{time} {icon}";
            format-icons = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          pulseaudio = {
            max-volume = 150;
            scroll-step = 10;
            format = "{icon}";
            format-bluetooth = "  ";
            tooltip-format = "{volume}%";
            format-muted = "  ";
            format-icons = {
              "alsa_output.usb-Lenovo_Lenovo_USB-C_Dock_USB_Audio_000000000000-00.analog-stereo" = "  ";
              headphone = "  ";
              default = [
                "  "
                "  "
                "   "
              ];
            };
            on-click = "pwvucontrol";
          };
          "custom/nix-updates" = {
            exec = "~/.config/waybar/update";
            signal = 12;
            on-click = "";
            on-click-right = "rm ~/.cache/nix-update-last-run";
            interval = 3600;
            tooltip = true;
            return-type = "json";
            format = "{} {icon}";
            format-icons = {
              has-updates = "󰚰";
              updating = "";
              updated = "";
              error = "";
            };
          };
        };
      };
      style = builtins.readFile ../../config/waybar/style.css;
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
          {
            monitor = "";
            text = "cmd[update:1000] echo $(cat /sys/class/power_supply/BAT0/capacity)%";
            color = "rgba(255, 255, 255, 1.0)";
            font_size = 14;
            position = "0, -30%";
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
