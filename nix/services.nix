{
  pkgs,
  inputs,
  ...
}:

{
  services.pinchflat.enable = true;
  services.pinchflat.selfhosted = true;

  # services.jellyfin = {
  #   enable = true;
  #   dataDir = config.services.pinchflat.mediaDir;
  # };

  # services.calibre-server = {
  #   enable = true;
  #   port = 4040;
  #   openFirewall = true;
  #   user = "yechiel";
  #};

  services.upower.criticalPowerAction = "Hibernate";

  services.udev.packages = [ pkgs.via ];

  services.udev.extraRules = ''
    # via keyboard
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  services.resolved = {
    enable = false;
    fallbackDns = [
      "8.8.8.8"
      "100.100.100.100"
      "127.0.0.53"
    ];
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us,il";
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.ly.enable = true;
  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  services.upower.enable = true;
  services.desktopManager.gnome.enable = true;

  # nix.settings = {
  # };

  services.printing.enable = true;

  # hardware.pulseaudio.enable = false;
  services.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.graphics.enable32Bit = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.openssh.enable = true;
  services.fwupd.enable = true;

  services.teamviewer.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraSetFlags = [
      "--operator=yechiel"
      "--accept-dns=false"
    ];
    extraUpFlags = [
      "--ssh"
      "--advertise-exit-node"
    ];
  };

  services.kanata = {

    enable = false;
    keyboards.my = {
      configFile = ../config/katana/kanata.kbd;
      #:: devices = [ ];
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

    };
  };

  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  services.flatpak = {
    enable = true;
    packages = [
      # "us.zoom.Zoom"
      #"com.usebottles.bottles"
      #"io.github.zen_browser.zen"
      #"org.kiwix.desktop"
    ];
    overrides = {
      global = {
        # Force Wayland by default
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];

        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "$HOME/.icons";

          # Force correct theme for some GTK apps
          GTK_THEME = "WhiteSur-Dark";
        };
      };

    };
  };
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
  };
}
