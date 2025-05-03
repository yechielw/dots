{ pkgs, config, ... }:
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

    kernelParams = [ "usbcore.autosuspend=-1" ];

    # nvidia stuuf for wayland
    #kernelParams = [ "quiet"];
    #kernelParams = [ "btusb.enable_autosuspend=0" ];
    #extraModulePackages = [config.boot.kernelPackages.ddcci-driver];

    #kernelModules = [ "i2c-dev" ]; # "ddcci_backlight"];

    kernelPackages = pkgs.linuxPackages_testing;

    # extraModprobeConfig = ''
    extraModprobeConfig = ''
      options btusb enable_autosuspend=N
      options iwlwifi power_save=0
    '';
    #   options iwlwifi 11n_disable=1
    #   options iwlwifi power_save=0
    #   options iwlwifi bt_coex_active=0
    # '';

  };

}
