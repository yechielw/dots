{
  lib,
  config,
  pkgs,
  ...
}:
let
  tahoe = pkgs.stdenv.mkDerivation {
    name = "macos-tahoe-theme";
    version = "v0.6.2";
    src = pkgs.fetchFromGitHub {
      owner = "kayozxo";
      repo = "GNOME-macOS-Tahoe";
      tag = "v0.6.2";
      sha256 = "sha256-Sp0ejlXy/cW6GFY0llD7JV5t1pWaHs7vG05ch7rF4Oo=";
    };

    nativeBuildInputs = with pkgs; [
      dialog
      glib
      jdupes
      libxml2
      sassc
      util-linux
    ];

    buildInputs = with pkgs; [
      gnome-themes-extra
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes
      cp -R gtk/Tahoe-Dark $out/share/themes
      cp -R gtk/Tahoe-Light $out/share/themes

      runHook postInstall
    '';
  };
in
{
  options.hm.appearance = {
    enable = lib.mkEnableOption "appearance";
  };
  config = lib.mkIf config.hm.appearance.enable {

    home.file.".config/gtk-4.0" = {
      enable = true;
      recursive = true;
      source = (tahoe + "/share/themes/Tahoe-Dark/gtk-4.0");
    };
    gtk = {
      enable = true;
      theme = {
        # name = "adw-gtk3-dark"; # "WhiteSur-Dark";
        # package = pkgs.adw-gtk3; # pkgs.whitesur-gtk-theme;
        name = "Tahoe-Dark";
        package = tahoe;
      };
      gtk4.theme = null;

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
      platformTheme.name = "adwaita";
      # style.name = "adwaita";
    };
  };
}
