{ pkgs
, inputs
, ...
}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.vicinae.nixosModules.default
  ];

  # services.pinchflat.enable = true;
  # services.pinchflat.selfhosted = true;

  # services.jellyfin = {
  #   enable = true;
  #   dataDir = config.services.pinchflat.mediaDir;
  # };

  # services.calibre-server = {
  #   enable = true;
  #   port = 4040;
  #   openFirewall = true;
  #   user = "yechiel";
  #};

  services.upower.criticalPowerAction = "Hibernate";

  services.udev.packages = [ pkgs.via ];

  services.udev.extraRules = ''
    # via keyboard
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  services.xserver = {
    enable = true;
    xkb.layout = "us,il";
  };

  # Enable the GNOME Desktop Environment.
  #services.displayManager.cosmic-greeter.enable = true;
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/yechiel";
  };
  #  services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.sddm.theme = "${
  #   pkgs.where-is-my-sddm-theme.override { variants = [ "qt5" ]; }
  # }/share/sddm/themes/where_is_my_sddm_theme_qt5";
  systemd.services.display-manager.stopIfChanged = false;
  # systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  services.upower.enable = true;
  services.desktopManager.gnome.enable = true;

  # nix.settings = {
  # };

  services.printing.enable = true;

  # hardware.pulseaudio.enable = false;
  services.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.graphics.enable32Bit = true;

  services.pipewire = {
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

  services.openssh.enable = true;
  services.fwupd.enable = true;

  services.teamviewer.enable = true;

  services.tailscale = {
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

  services.kanata = {
    enable = true;
    keyboards.my = {
      configFile = ../../../../config/katana/kanata.kbd;
      #:: devices = [ ];
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
    };
  };

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
    settings = {
      substituters = [
        "https://vicinae.cachix.org"
        #          "ssh://eu.nixbuild.net"
      ];
      trusted-public-keys = [
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "nixbuild.net/ZIB0CP-1:ApkQd3BTT++gJj9vh8e58TDvpZOXdc76S4vkFP1zqhA="
      ];
    };
  };
  services.flatpak = {
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
  # services.espanso = {
  #   enable = true;
  #   package = pkgs.espanso-wayland;
  # };
}
