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
    ../hacking.nix
    ../work.nix
    ../term.nix
    ../wm.nix
    ../vm.nix
    ../boot.nix
    ../override.nix
    ../security.nix
    ../home/home.nix
  ];

  hardware.firmware = [ pkgs.sof-firmware ];

  boot = {

    kernelParams = [ "usbcore.autosuspend=-1" ];

    extraModprobeConfig = ''
      options btusb enable_autosuspend=N
      options iwlwifi power_save=0
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
