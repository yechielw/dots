{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.hm.appearance = {
    enable = lib.mkEnableOption "appearance";
  };
  config = lib.mkIf config.hm.appearance.enable {

    home = {
      pointerCursor = {
        enable = true;
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
        x11.enable = true;
      };
    };

    home.file.".config/gtk-4.0" = {
      enable = true;
      force = true;
      recursive = true;
      source = (pkgs.yechiel.tahoe + "/share/themes/MacTahoe-Dark/gtk-4.0");
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
  };
}
