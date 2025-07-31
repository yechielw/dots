{
  pkgs,
  inputs,
  settings,
  pkgs-master,
  profilepic,
  stable,
  ...
}:

{

  programs = {
    # zoom-us.enable = true;
    # zoom-us.package = pkgs.zoom-us.overrideAttrs (oldAttrs: {
    #   src = pkgs.fetchurl {
    #     url = "https://zoom.us/client/6.0.2.4680/zoom_x86_64.pkg.tar.xz";
    #     hash = "sha256-027oAblhH8EJWRXKIEs9upNvjsSFkA0wxK1t8m8nwj8=";
    #   };
    # });
    nh = {
      enable = true;
      clean.enable = true;
      flake = "/home/${settings.username}/dots";
    };
    zsh.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    kdeconnect.enable = true;
    java.enable = true;

  };
}
