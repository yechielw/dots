{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.omniflake.pinned.nix-flatpak.nixosModules.nix-flatpak
  ];

  systemd.services.display-manager.stopIfChanged = false;
  # systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";

  hardware.graphics.enable32Bit = true;

  nix = {
    # distributedBuilds = true;
    # buildMachines = [
    #   {
    #     hostName = "eu.nixbuild.net";
    #     system = "x86_64-linux";
    #     maxJobs = 100;
    #     supportedFeatures = [
    #       "benchmark"
    #       "big-parallel"
    #     ];
    #   }
    # ];
  };

  services = {
    upower = {
      criticalPowerAction = "Hibernate";
      enable = true;
    };

    udev = {
      packages = [ pkgs.via ];

      extraRules = ''
        # via keyboard
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
    };

    xserver = {
      enable = true;
      xkb.layout = "us,il";
    };

    # Enable the GNOME Desktop Environment.
    # displayManager.cosmic-greeter.enable = true;
    displayManager.dms-greeter = {
      enable = true;
      compositor.name = "hyprland";
      compositor.customConfig = ''
        hl.env("DMS_RUN_GREETER", "1")

        hl.config({
            misc = {
                disable_hyprland_logo = true,
            },
        })

        hl.on("hyprland.start", function()
            hl.exec_cmd("sh -c \"dms; hyprctl dispatch exit\"")
        end)
      '';
      configHome = "/home/yechiel";
    };
    desktopManager.gnome.enable = true;

    printing.enable = true;

    # hardware.pulseaudio.enable = false;
    pulseaudio.package = pkgs.pulseaudioFull;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      jack.enable = true;

      wireplumber.extraConfig."60-prioritize-bluetooth" = {
        "monitor.bluez.rules" = [
          {
            matches = [
              { "node.name" = "~bluez_output.*"; }
            ];
            actions.update-props = {
              "priority.session" = 3000;
            };
          }
        ];
      };

      #   "monitor.alsa.rules" = [
      #     {
      #       matches = [
      #         { "node.name" = "~alsa_output.*"; }
      #       ];
      #       actions.update-props = {
      #         "priority.session" = 1000;
      #       };
      #     }
      #   ];
      # };

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    openssh.enable = true;
    fwupd.enable = true;

    teamviewer.enable = true;

    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      extraSetFlags = [
        "--operator=yechiel"
        "--accept-dns=true"
        "--accept-routes=true"
      ];
      extraUpFlags = [
        "--ssh"
        "--advertise-exit-node"
      ];
    };

    kanata = {
      enable = true;
      keyboards.home-row = {
        configFile = ./kanata.kbd;
        #:: devices = [ ];
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      };
    };

    flatpak = {
      enable = true;
      packages = [
        "io.github.maniacx.BudsLink"
        # "us.zoom.Zoom"
        #"com.usebottles.bottles"
        #"io.github.zen_browser.zen"
        #"org.kiwix.desktop"
      ];
      overrides = {
        global = {
          # Force Wayland by default
          Context.sockets = [
            "wayland"
            "!x11"
            "!fallback-x11"
          ];

          Environment = {
            # Fix un-themed cursor in some Wayland apps
            XCURSOR_PATH = "$HOME/.icons";

            # Force correct theme for some GTK apps
            GTK_THEME = "WhiteSur-Dark";
          };
        };
      };
    };
    # espanso = {
    #   enable = true;
    #   package = pkgs.espanso-wayland;
    # };
  };
}
