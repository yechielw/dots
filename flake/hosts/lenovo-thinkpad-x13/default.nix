{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel

    # inputs.espanso-fix.nixosModules.espanso-capdacoverride
    # inputs.chaotic.nixosModules.nyx-cache
    # inputs.chaotic.nixosModules.nyx-overlay
    # inputs.chaotic.nixosModules.nyx-registry

    ./hardware-configuration.nix
    ../../modules/nixos/profiles/base.nix
    ../../modules/nixos/profiles/desktop.nix
    ../../modules/nixos/profiles/tui.nix
    ../../modules/nixos/profiles/development.nix
    ../../modules/nixos/profiles/cyber.nix
    ../../modules/nixos/profiles/virtualization.nix
    ../../modules/nixos/profiles/work.nix
    ../../modules/nixos/profiles/laptop.nix
    ../../modules/nixos/citrix-secure-access
  ];

  # hardware.firmware = [ pkgs.sof-firmware ];

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
