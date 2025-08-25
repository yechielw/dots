{ lib, config, pkgs, ... }: {
  options.hm.appearance = {
    enable = lib.mkEnableOption "appearance";
  };
  config = lib.mkIf config.hm.appearance.enable {
    gtk = {
      enable = true;
      theme = {
        name = "WhiteSur-Dark";
        package = pkgs.whitesur-gtk-theme;
      };

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        # name = "WhiteSur";
        # package = pkgs.whitesur-icon-theme;
      };

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
      platformTheme.name = "gtk";
      style.name = "gtk2";
    };
  };
}