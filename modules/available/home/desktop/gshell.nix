{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    custom.bar = lib.mkOption {
      type = lib.types.enum [
        "waybar"
        "ashell"
        "dms"
      ];
      default = "dms";
    };
  };
}
