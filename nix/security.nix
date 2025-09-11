{
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.howdy-module.nixosModules.default
  ];

  services.howdy.enable = true;
  services.howdy.settings.video.dark_threshold = 80;
  environment.sessionVariables.OMP_NUM_THREADS = 1;
  services.linux-enable-ir-emitter.enable = true;

  services.fprintd.enable = true;

}
