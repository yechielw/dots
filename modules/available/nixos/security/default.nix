{ lib, ... }:
{
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

  security = {
    run0.enable = true;
    run0.enableSudoAlias = true;
    sudo.enable = false;

    rtkit.enable = true;
    polkit.enable = true;

    pki.certificateFiles = lib.filesystem.listFilesRecursive ./certs;
  };
}
