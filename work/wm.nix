{pkgs,inputs, ...}:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    wofi
    nwg-look
    nwg-panel
    nwg-drawer
    nwg-displays
    nwg-clipman
    cliphist
    wl-clipboard
    polkit_gnome
    kdePackages.qtwayland
    brightnessctl
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    inputs.hyprpanel.packages.${pkgs.system}.default
    inputs.quickshell.packages.${pkgs.system}.default
    adw-gtk3
    whitesur-gtk-theme
    waybar
    networkmanagerapplet
    blueman
    blueberry
    ulauncher




    #ags 
    bun
    dart-sass
    swww
    matugen
    hyprpicker
    slurp
    grim
    satty
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    asusctl
    supergfxctl
    libdbusmenu-gtk3


  ];



  #  services.blueman.enable = true;
  services.hypridle.enable = true;

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

}
