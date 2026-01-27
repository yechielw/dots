{
  pkgs,
  config,
  inputs,
  ...
}:
{

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    #    plymouth.themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
    # plymouth.theme = "catppuccin-mocha";
    initrd.systemd.enable = true;

    # secureboot enabled systemdboot dropin repolacement
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    kernelPackages = pkgs.linuxPackages_testing;
    # kernelPackages = pkgs.linuxPackages_zen;
    # kernelPackages = pkgs.linuxPackages_zen;

  };
}
