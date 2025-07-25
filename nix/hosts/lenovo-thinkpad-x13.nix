{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13
  ];

  hardware.firmware = [ pkgs.sof-firmware ];

  boot = {

    kernelParams = [ "usbcore.autosuspend=-1" ];

    extraModprobeConfig = ''
      options btusb enable_autosuspend=N
      options iwlwifi power_save=0
    '';
  };

  systemd.services = {
    enableModem = {
      description = "Enable Quectel Modem on Startup";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = [ "${pkgs.libmbim}/bin/mbimcli -p -d /dev/cdc-wdm0 --quectel-set-radio-state=on" ];
      };
    };
  };

}
