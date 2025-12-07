{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel

    inputs.espanso-fix.nixosModules.espanso-capdacoverride
    inputs.chaotic.nixosModules.nyx-cache
    inputs.chaotic.nixosModules.nyx-overlay
    inputs.chaotic.nixosModules.nyx-registry

    ./hardware-configuration.nix

    ../configuration.nix
    ../packages.nix
    ../programs.nix
    ../services.nix
    ../modules/nixosModules/hacking.nix
    ../work.nix
    ../term.nix
    ../modules/nixosModules/wm.nix
    ../vm.nix
    ../boot.nix
    ../override.nix
    ../security.nix
    ../home/home.nix
  ];

  # hardware.firmware = [ pkgs.sof-firmware ];

  boot = {

    kernelParams = [ "usbcore.autosuspend=-1" ];

    extraModprobeConfig = ''
      options btusb enable_autosuspend=N
      # options iwlwifi power_save=0
      # options iwlwifi bt_coex_active=0
    '';
  };

  # systemd.services = {
  #   enableModem = {
  #     description = "Enable Quectel Modem on Startup";
  #     after = [
  #       "network.target"
  #       "ModemManager.service"
  #     ];
  #     wantedBy = [ "multi-user.target" ];
  #     serviceConfig = {
  #       Type = "oneshot";
  #       ExecStart = [ "${pkgs.libmbim}/bin/mbimcli -p -d /dev/cdc-wdm0 --quectel-set-radio-state=on" ];
  #     };
  #   };
  # };
  systemd.tmpfiles.rules = [
    "d /var/lib/linux-enable-ir-emitter 0755 root root - -"
  ];
  environment.etc."linux-enable-ir-emitter".source = ../../config/linux-enable-ir-emitter;



  services.udev.extraRules = ''
    # AX211 Bluetooth
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0033", ATTR{authorized}="1"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0033", ATTR{power/autosuspend}="-1"
  '';
  hardware.bluetooth = {
    enable = true;

    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        ControllerMode = "dual";
        JustWorksRepairing = "confirm";
        Privacy = "device";
        # Enhanced timeout and retry settings for firmware loading
        DiscoverableTimeout = 0;
        PairableTimeout = 0;
        AutoConnectTimeout = 60;
        # Experimental features that may help with MT7925
      };
      Policy = {
        AutoEnable = true;
        ReconnectAttempts = 7;
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
    };
  };



  networking = {
    hostName = "lenovo-thinkpad-x13";
    modemmanager = {
      enable = true;
      package = pkgs.modemmanager;

      fccUnlockScripts = [
        (rec {
          id = "2c7c:030a";
          path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/${id}";
        })
      ];
    };
  };

}
