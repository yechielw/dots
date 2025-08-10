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
    zoom-us.enable = true;
    # zoom-us.package = pkgs-master.zoom-us;
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
