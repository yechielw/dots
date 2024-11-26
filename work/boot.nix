{...}:
{

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
    #plymouth.enable = true;
    initrd.systemd.enable = true;

    # secureboot enabled systemdboot dropin repolacement
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  

    # nvidia stuuf for wayland
    #kernelParams = [ "quiet"];
    #extraModulePackages = [config.boot.kernelPackages.ddcci-driver];

    kernelModules = [ "i2c-dev" ]; #"ddcci_backlight"];



    extraModprobeConfig = ''
      options iwlwifi 11n_disable=1
      options iwlwifi power_save=0
      options iwlwifi bt_coex_active=0
    '';

    };

}
