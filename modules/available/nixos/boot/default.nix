{ pkgs
, inputs
, ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.chaotic.nixosModules.default
  ];

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

    kernelPackages = pkgs.linuxPackages_cachyos;
    # kernelPackages = pkgs.linuxPackages_zen;
  };
}
