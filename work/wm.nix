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



  services.blueman.enable = true;


}
