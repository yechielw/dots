{pkgs,inputs,config,lib, ...}:
{
  options = {
    wm.enable = lib.mkEnableOption "enable window manager (hyprland)";
  };

  config =  lib.mkIf config.wm.enable {
    nix.settings = {
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
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };
    
    security.pam.services.gdm.enableGnomeKeyring = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      swayosd
      wofi
      nwg-displays
      wl-clipboard
      polkit_gnome
      pwvucontrol
      pavucontrol
      kdePackages.qtwayland
      brightnessctl
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      adw-gtk3
      waybar
      networkmanagerapplet
      ulauncher
      hyprlock
      hyprpicker
      slurp
      grim
      satty
      wayshot
    ];

    services = {
      hypridle.enable = true;
      blueman.enable = true;
      gnome.gnome-keyring.enable = true;
      logind = {
        #lidSwitch = "hibernate";
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "lock";
      };
    };
    #  security.pam.services.gdm-password.enableGnomeKeyring = true;

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
        enable = true;
      };
    };
  };
}
