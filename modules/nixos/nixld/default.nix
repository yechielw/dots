{
  config,
  lib,
  pkgs,
  ...
}: {
  options.profiles.nixld.enable = lib.mkEnableOption "nix-ld compatibility profile";

  config = lib.mkIf config.profiles.nixld.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libcxx
        xorg.libSM
        xorg.libICE
        icu
        libgcc.lib
        e2fsprogs
        libdrm
        mesa
        fontconfig
        freetype
        fribidi
        libgbm
        libGL
        libgpg-error
        harfbuzz
        gcc
        xorg.libX11
        #libX11_xcb
        xorg.libxcb
        zlib
        gvfs # Add gvfs for the missing symbols
        glib # Add glib for GIO-related errors
        xorg.xkbcomp
        #xorg # Add X11 and XKB config
        #stdenv.cc.cc
        #zlib
        #fuse3
        #icu
        #nss
        #openssl
        #curl
        #expat
        # ...
      ];
    };
  };
}
