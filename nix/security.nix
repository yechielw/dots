{
  pkgs,
  config,
  inputs,
  howdy-pr,
  ...
}: let
  # Access the specific package set from the PR input
  prPkgs = howdy-pr.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    #inputs.howdy-module.nixosModules.default
    ./overlays/howdy.nix
  ];

  services.howdy.enable = true;
  services.howdy.package = prPkgs.howdy;
  services.linux-enable-ir-emitter.package = prPkgs.linux-enable-ir-emitter;
  services.howdy.settings.video.dark_threshold = 80;
  environment.sessionVariables.OMP_NUM_THREADS = 1;
  services.linux-enable-ir-emitter.enable = true;

  services.fprintd.enable = true;

}
