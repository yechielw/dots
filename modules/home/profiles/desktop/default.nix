{
  lib,
  config,
  ...
}: {
  options.profiles.desktop.enable = lib.mkEnableOption "desktop Home Manager profile";

  config = lib.mkIf config.profiles.desktop.enable {
    hm.appearance.enable = true;
    hm.hypr.enable = true;
    wm.enable = true;
  };
}
