{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

let
  lock_cmd = if config.custom.bar == "dms" then "dms ipc call lock lock" else "hyprlock";
in
{
  imports = [
    ./hyprland.nix
    ./vicinae.nix
    ./term.nix
    ./bar.nix
    ./gshell.nix
  ];

  home = {
    pointerCursor = {
      enable = true;
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      x11.enable = true;
    };

    sessionVariables.NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.file.".config/gtk-4.0" = {
    enable = true;
    force = true;
    recursive = true;
    source = pkgs.yechiel.tahoe + "/share/themes/MacTahoe-Dark/gtk-4.0";
  };

  gtk = {
    enable = true;
    theme = {
      name = "MacTahoe-Dark";
      package = pkgs.yechiel.tahoe;
    };
    gtk4.theme = {
      name = "MacTahoe-Dark";
      package = pkgs.yechiel.tahoe;
    };

    # iconTheme = {
    # name = "WhiteSur";
    # package = pkgs.whitesur-icon-theme;
    # };

    font = {
      name = "SFProText Nerd Font";
      size = 11;
    };

    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    # style.name = "adwaita";
  };

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };

  # xdg.portal.configPackages = [
  #   pkgs.xdg-desktop-portal-hyprland
  #   pkgs.xdg-desktop-portal-gtk
  # ];
  services = {
    kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "internal";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              scale = 1.0;
            }
          ];
        }
        {
          profile.name = "work";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              position = "3840,0";
              scale = 1.0;
            }
            {
              criteria = "Lenovo Group Limited E24-28 VVQ36240";
              status = "enable";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "Lenovo Group Limited E24-28 VVQ36235";
              status = "enable";
              position = "1920,0";
              scale = 1.0;
            }
          ];
        }
        {
          profile.name = "home";
          profile.outputs = [
            {
              criteria = "eDP-1";
              position = "1920,0";
              scale = 1.0;
            }
            {
              criteria = "HP Inc. HP V24i 1CR1161GPX";
              status = "enable";
              position = "0,0";
              scale = 1.0;
            }
          ];
        }
      ];
    };

    #  awww.enable = true;
    # icalnotifier.enable = true;
    # icalnotifier.package = inputs.icalindicator.packages.${pkgs.stdenv.hostPlatform.system}.default;
    tailscale-systray.enable = true;

    network-manager-applet.enable = true;

    gnome-keyring.enable = true;

    kdeconnect = {
      enable = true;
      indicator = true;
    };

    #battery-notify.enable = true;

    udiskie.enable = true;
    swayosd = {
      enable = false;
      topMargin = 0.75;
    };

    blueman-applet.enable = true;
    flameshot.enable = true;
    flameshot.settings.General = {
      contrastOpacity = 196;
      drawThickness = 5;
      saveAfterCopy = true;
      savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
      showDesktopNotification = false;
      showStartupLaunchMessage = false;
      uploadWithoutConfirmation = true;
      # useGrimAdapter = true;
    };
    # hyprpolkitagent.enable = true;
    polkit-gnome.enable = true;

    hyprpaper = {
      enable = config.custom.bar != "dms";
      settings = {
        ipc = "on";
        # splash = false;
        splash_offset = 2.0;
        wallpaper = [
          {
            monitor = ",";
            path = "/home/yechiel/Downloads/thinknix-d.png";
          }
        ];
      };
    };

    hyprsunset = {
      enable = true;
    };

    hypridle = {
      enable = true;

      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
          lock_cmd = lock_cmd;
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
          }
          {
            timeout = 300;
            on-timeout = "brightnessctl -sd tpacpi::kbd_backlight set 0";
            on-resume = "brightnessctl -rd tpacpi::kbd_backlight";
          }
          {
            timeout = 350;
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'  && brightnessctl -r";
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

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--disable-ipc-flooding-protection"
      "--disable-xss-auditor"
      "--disable-bundled-ppapi-flash"
      "--disable-plugins-discovery"
      "--disable-default-apps"
      "--disable-prerender-local-predictor"
      "--disable-breakpad"
      "--disable-crash-reporter"
      "--disable-prerender-local-predictor"
      "--disk-cache-size=0"
      "--disable-settings-window"
      "--disable-notifications"
      "--disable-speech-api"
      "--disable-file-system"
      "--disable-presentation-api"
      "--disable-permissions-api"
      "--disable-new-zip-unpacker"
      "--disable-media-session-api"
      "--no-experiments"
      "--no-events"
      "--no-first-run"
      "--no-default-browser-check"
      "--no-pings"
      "--no-service-autorun"
      "--media-cache-size=0"
      "--use-fake-device-for-media-stream"
      "--dbus-stub"
      "--disable-background-networking"
      "--disable-features=ChromeWhatsNewUI,HttpsUpgrades,ImageServiceObserveSyncDownloadStatus,LensOverlay,RenderDocument,SessionRestoreInfobar,TrackingProtection3pcd"
      "--proxy-server=localhost:8080"
      "'--proxy-bypass-list=<-loopback>'"
      "--user-data-dir=/home/yechiel/.BurpSuite/pre-wired-browser"
      "--ignore-certificate-errors"
      "--load-extension=/home/yechiel/.BurpSuite/new-tab,/home/yechiel/.BurpSuite/navigation-recorder,/home/yechiel/.BurpSuite/dom-invader"
    ];
    # extensions = [
    #   {
    #     crxPath = "/home/yechiel/.BurpSuite/new-tab";
    #   }
    #   {
    #     crxPath = "/home/yechiel/.BurpSuite/navigation-recorder";
    #   }
    #   {
    #     crxPath = "/home/yechiel/.BurpSuite/dom-invader";
    #   }
    # ];
  };

  programs.google-chrome = {
    enable = lib.mkDefault true;
    commandLineArgs = [
      "--disable-features=WaylandWpColorManagerV1"
      "--password-store=basic"
      "--enable-features=VerticalTabs"
    ];
  };
  wayland.windowManager.hyprland.settings.bind = [
    {
      _args = [
        "SUPER + escape"
        (lib.generators.mkLuaInline "hl.dsp.exec_cmd \"${lock_cmd}\" ")
      ];

    }
  ];
}
