{
  lib,
  config,
  ...
}: {
  options.profiles.tui.enable = lib.mkEnableOption "terminal Home Manager profile";

  config = lib.mkIf config.profiles.tui.enable {
    hm.tui.enable = true;
  };
}
