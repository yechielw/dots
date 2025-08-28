{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  options = {
    wm.enable = lib.mkEnableOption "enable window manager (hyprland)";
  };

  config = lib.mkIf config.wm.enable {
    nix.settings = {
      trusted-users = [ "@wheel" ];
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    programs = {
      firefox.enable = true; # left becaus its default
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;

      };
      hyprland = {
        enable = true;
        withUWSM = true;
        # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        # portalPackage =
        #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
      hyprlock.enable = true;
    };

    #security.pam.services.gdm.enableGnomeKeyring = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
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
      #inputs.quickshell.packages.${pkgs.system}.default
      # inputs.walker.packages.${pkgs.system}.default
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
    security.pam.services.gdm-password.enableGnomeKeyring = true;
  };
}
