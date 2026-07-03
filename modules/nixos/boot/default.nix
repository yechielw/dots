{ pkgs
, config
, inputs
, lib
, ...
}:
{
  options.profiles.boot.enable = lib.mkEnableOption "boot profile";

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  config = lib.mkIf config.profiles.boot.enable {
    boot = {
      loader = {
        systemd-boot.enable = false;
        systemd-boot.configurationLimit = 5;
        efi.canTouchEfiVariables = true;
      };
      # plymouth.enable = true;
      #    plymouth.themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      # plymouth.theme = "catppuccin-mocha";
      initrd.systemd.enable = true;

      # Secure Boot-enabled systemd-boot replacement.
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          # autoReboot = true;
        };
        measuredBoot = {
          enable = true;
          pcrs = [
            0
            4
            7
          ];
        };
      };

      #kernelPackages = pkgs.linuxPackages_testing;
      #kernelPackages = inputs.nyx-loner.packages.${pkgs.stdenv.hostPlatform.system}.linux_cachyos-lto;
      kernelPackages = pkgs.linuxPackages_zen;
      # kernelPackages = pkgs.linuxPackages_zen;

    };
  };
}
