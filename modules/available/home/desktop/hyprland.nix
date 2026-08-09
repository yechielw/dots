{
  xdg.configFile."hypr/main".source = ./lua/main;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    extraLuaFiles = {
      main.content = ./lua/main/init.lua;
    };
  };
}
