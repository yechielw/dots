{
  pkgs,
  inputs,
  settings,
  pkgs-master,
  profilepic,
  ...
}:

{
  # custom module with all window  manager stuff
  wm.enable = true;

  # services.clamav = {
  #   daemon.enable = true;
  #   updater.enable = true;
  #   scanner.enable = true;
  # };
  services.upower.criticalPowerAction = "Hibernate";

  services.udev.packages = [ pkgs.via ];

  services.udev.extraRules = ''
    # ACTION=="add", KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users"
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

  networking = {
    hostName = settings.hostname; # Define your hostname.
    nameservers = [
      #"127.0.0.53"
      #"100.100.100.100"
      #"8.8.8.8"
      #"8.8.4.4"
    ];
    search = [ "bowfin-marlin.ts.net" ];
    firewall = {
      allowedTCPPorts = [
        8080
        4444
        46387
      ];
    };
    networkmanager = {
      enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us,il";
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  # nix.settings = {
  # };

  environment.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # hardware.pulseaudio.enable = false;
  services.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.graphics.extraPackages = [ pkgs.intel-compute-runtime ];

  hardware.bluetooth = {
    enable = true;
  };

  hardware.i2c.enable = true;
  hardware.keyboard.qmk.enable = true;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pki.certificateFiles = pkgs.lib.filesystem.listFilesRecursive ../config/certs;

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

  fonts = {
    fontDir.enable = true;

    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-mono
      corefonts
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "SFProText Nerd Font" ];
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
    };
  };

  environment.pathsToLink = [
    "/share/zsh"
  ]; # needed for zsh completion declared in zsh config

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.fwupd.enable = true;

  services.fprintd.enable = true;

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

  services.flatpak = {
    enable = true;
    packages = [
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
  # services.espanso = {
  #   enable = true;
  #   package = pkgs.espanso-wayland;
  # };

  systemd.tmpfiles.rules = [
    "L /usr/share/X11/xkb/rules/base.xml - - - - ${pkgs.xkeyboard_config}/share/X11/xkb/rules/base.xml"
    "L /var/lib/AccountsService/icons/${settings.username} - - - - ${profilepic}"
  ];

  system.stateVersion = "24.05"; # "24.05"; # Did you read the comment?

  nix = {
    settings = {
      lazy-trees = true;

      # experimental-features = [
      #   "nix-command"
      #   "flakes"
      # ];
      auto-optimise-store = true;
    };
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 14d";
    # };
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      android_sdk.accept_license = true;
    };
  };

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      flake = "/home/${settings.username}/dots";
    };
    zsh.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    kdeconnect.enable = true;
    java.enable = true;

  };
  users.defaultUserShell = pkgs.zsh;

  #virtualisation.libvirtd.enable = true;
  #programs.virt-manager.enable = true;

}
