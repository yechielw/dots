{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.dms.nixosModules.default
  ];
  options.profiles.wm.enable = lib.mkEnableOption "enable window manager (hyprland)";

  config = lib.mkIf config.profiles.wm.enable {
    nix.settings = {
      trusted-users = [ "@wheel" ];
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    services.udisks2.enable = true;
    systemd.user.services = {
      "wayland-session-bindpid@" = {
        restartIfChanged = false;
        stopIfChanged = false;
      };
      "wayland-wm@" = {
        restartIfChanged = false;
        stopIfChanged = false;
      };
      "wayland-wm-env@" = {
        restartIfChanged = false;
        stopIfChanged = false;
      };
    };
    # services.desktopManager.cosmic.enable = true;
    #specialisation.cosmic.configuration.services.desktopManager.cosmic.enable = true;
    # specialisation.zen.configuration.boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
    xdg.portal.config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };

    programs = {
      dank-material-shell = {

        enable = true;

        systemd = {
          enable = true; # Systemd service for auto-start
          restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
        };

        # Core features
        enableSystemMonitoring = true; # System monitoring widgets (dgop)
        enableVPN = true; # VPN management widget
        enableDynamicTheming = true; # Wallpaper-based theming (matugen)
        enableAudioWavelength = true; # Audio visualizer (cava)
        enableCalendarEvents = true; # Calendar integration (khal)
        enableClipboardPaste = true; # Pasting from the clipboard history (wtype)
      };
      seahorse.enable = true;
      # dwl.enable = true;
      firefox.enable = true; # left becaus its default
      # sway = {
      #   enable = true;
      #   wrapperFeatures.gtk = true;
      #
      # };
      hyprland = {
        enable = true;
        # withUWSM = true;
        #  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
      hyprlock.enable = false;
    };
    security.pam.services.hyprlock.text = "auth include login";

    #security.pam.services.gdm.enableGnomeKeyring = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      nautilus
      st
      swayosd
      gnome-themes-extra
      gtk-engine-murrine
      wofi
      # nwg-displays
      wl-clipboard
      polkit_gnome
      pwvucontrol
      pavucontrol
      kdePackages.qtwayland
      brightnessctl
      rose-pine-hyprcursor
      #inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
      # inputs.walker.packages.${pkgs.stdenv.hostPlatform.system}.default
      qt6.qtmultimedia
      adw-gtk3
      waybar
      networkmanagerapplet
      #ulauncher
      hyprlock
      hyprpicker
      slurp
      grim
      satty
      wayshot
      libnotify
      gtk4
      libadwaita
      adwaita-icon-theme
      hicolor-icon-theme
    ];

    services = {
      #hypridle.enable = true;
      blueman.enable = true;
      gnome = {
        gnome-keyring.enable = true;
        sushi.enable = true;
        rygel.enable = true;
      };
      #gnome.gnome-keyring.enable = true;
      # services.logind.settings.Login.HandleLidSwitchDocked
      logind.settings.Login = {
        lidSwitch = "hybrid-sleep";
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "lock";
      };
    };
    #   security.pam.services.gdm-password.enableGnomeKeyring = true;
    security.pam.services.login.enableGnomeKeyring = true;

  };
}
