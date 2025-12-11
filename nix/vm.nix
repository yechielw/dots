{ config, pkgs, ... }:

{

  boot.kernelModules = [
    "ip_tables"
    "iptable_nat"
  ];

  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
    quickemu
  ];

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  virtualisation.containers.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation = {
    docker = {
      enable = true;

    };
    podman = {
      enable = true;
      # dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  services.spice-vdagentd.enable = true;

}
