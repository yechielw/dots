{ pkgs
, config
, inputs
, lib
, ...
}:
{
  options.profiles.security.enable = lib.mkEnableOption "security and authentication profile";

  config = lib.mkIf config.profiles.security.enable {
    services = {
      howdy = {
        enable = true;
        control = "sufficient";
        settings.video.dark_threshold = 80;
      };

      linux-enable-ir-emitter.enable = true;

      fprintd.enable = true;

    };

    environment.sessionVariables.OMP_NUM_THREADS = 1;

    security.run0.enable = true;
    security.run0.enableSudoAlias = true;
    security.sudo.enable = false;
  };
}
