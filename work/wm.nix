{pkgs,inputs,config,lib, ...}:
{
  options = {
    wm.enable = lib.mkEnableOption "enable window manager (hyprland)";
  };

  config = lib.mkIf config.wm.enable {

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
      #nwg-look
      #nwg-panel
      #nwg-drawer
      nwg-displays
      wl-clipboard
      polkit_gnome
      pwvucontrol
      kdePackages.qtwayland
      brightnessctl
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      #inputs.hyprpanel.packages.${pkgs.system}.default
      adw-gtk3
      #    whitesur-gtk-theme
      waybar
      networkmanagerapplet
      #blueman
      #blueberry
      ulauncher
      hyprlock


      hyprpicker
      slurp
      grim
      satty
      #wf-recorder
      wl-clipboard
      wayshot
      #swappy
      #asusctl
      #supergfxctl
      #libdbusmenu-gtk3


    ];



    #  services.blueman.enable = true;
    services.hypridle.enable = true;
    services.blueman.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.logind.lidSwitch = "suspend-then-hibernate";
    services.logind.lidSwitchDocked = "ignore";
    services.logind.lidSwitchExternalPower = "lock";
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
