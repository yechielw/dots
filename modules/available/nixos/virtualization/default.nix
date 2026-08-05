{
  pkgs,
  ...
}:
{
  boot.kernelModules = [
    "ip_tables"
    "iptable_nat"
  ];

  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;

  networking = {
    nftables.enable = true;

    # Allow Incus guests to reach the bridge's DHCP and DNS services.
    firewall.trustedInterfaces = [ "incusbr0" ];
  };

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
    incus = {
      enable = true;

      preseed = {
        networks = [
          {
            config = {
              "ipv4.address" = "10.0.100.1/24";
              "ipv4.nat" = "true";
            };
            name = "incusbr0";
            type = "bridge";
          }
        ];
        profiles = [
          {
            devices = {
              eth0 = {
                name = "eth0";
                network = "incusbr0";
                type = "nic";
              };
              root = {
                path = "/";
                pool = "default";
                size = "35GiB";
                type = "disk";
              };
            };
            name = "default";
          }
        ];
        storage_pools = [
          {
            config = {
              source = "/var/lib/incus/storage-pools/default";
            };
            driver = "dir";
            name = "default";
          }
        ];
      };
    };

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
  # virtualisation.waydroid.enable = true;
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
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
