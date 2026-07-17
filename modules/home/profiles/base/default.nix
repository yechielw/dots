{
  lib,
  config,
  ...
}: {
  options.profiles.base.enable = lib.mkEnableOption "base Home Manager profile";

  config = lib.mkIf config.profiles.base.enable {
    programs.home-manager.enable = true;
  };
}
