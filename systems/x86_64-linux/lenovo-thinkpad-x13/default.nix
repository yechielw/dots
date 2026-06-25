{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel
    ./hardware-configuration.nix
  ];

  boot = {

    kernelParams = [ "usbcore.autosuspend=-1" ];

    extraModprobeConfig = ''
      options btusb enable_autosuspend=N
      # AX211 is a Wi-Fi/Bluetooth combo device; aggressive Wi-Fi power saving
      # tends to make Bluetooth audio less stable under load.
      options iwlwifi power_save=0 uapsd_disable=1
      options iwlmvm power_scheme=1
    '';
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/linux-enable-ir-emitter 0755 root root - -"
  ];
  environment.etc."linux-enable-ir-emitter".source = ../../../config/linux-enable-ir-emitter;

  services.udev.extraRules = ''
    # AX211 Bluetooth
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0033", ATTR{authorized}="1"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0033", ATTR{power/autosuspend}="-1"
  '';
  hardware.bluetooth = {
    enable = true;

    settings = {
      General = {
        ControllerMode = "bredr";
        JustWorksRepairing = "confirm";
        Privacy = "device";
        DiscoverableTimeout = 0;
        PairableTimeout = 0;
      };
      Policy = {
        AutoEnable = true;
        ReconnectAttempts = 7;
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
    };
  };

  snowfallorg.users.yechiel.home.path = "/home/yechiel/";

  networking = {
    hostName = "lenovo-thinkpad-x13";
    modemmanager = {
      enable = true;
      # package = pkgs.modemmanager;

      fccUnlockScripts = [
        {
          id = "2c7c:030a";
          path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/2c7c";
        }
      ];
    };
  };

  home-manager = {
    backupFileExtension = "bck";
    useUserPackages = true;
  };

}
