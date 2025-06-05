{
  pkgs,
  inputs,
  settings,
  pkgs-master,
  ...
}:

{
  # custom module with all window  manager stuff
  wm.enable = true;

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };
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
      # settings = {
      #   # Disable WiFi power management
      #   "connection" = {
      #     "wifi.powersave" = 2;
      #   };
      # };
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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # nix.settings = {
  # };

  environment.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # hardware.pulseaudio.enable = false;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.graphics.extraPackages = [ pkgs.intel-compute-runtime ];

  hardware.firmware = [ pkgs.sof-firmware ];
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        # ControllerMode = "bredr";
        # Enable = "Source,Sink,Media,Socket";
        #
      };
    };
  };

  hardware.i2c.enable = true;
  hardware.keyboard.qmk.enable = true;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pki.certificateFiles = [
    ../certs/netspark.pem
    ../certs/burp.pem
    ../certs/ca.crt
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    #wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
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
    "/share/qti"
  ]; # needed for zsh completion declared in zsh config

  environment.systemPackages =
    with pkgs;
    [
      clamav
      pkgs-master.bitwarden
      nixd
      alsa-utils
      beeper
      element-desktop
      ghostty
      obsidian
      xxd
      wirelesstools
      qmk
      via
      bluez-tools
      blueberry
      espanso-wayland
      nixfmt-rfc-style
      dig
      libmbim
      copyq
      (flameshot.override {
        enableWlrSupport = true;
        enableMonochromeIcon = true;
      })
      curl
      gcc
      file
      git
      go
      google-chrome
      gzip
      kitty
      neovim
      lua-language-server
      nodejs
      pipx
      pyenv
      thunderbird
      unzip
      wget
      killall
      cargo
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      podman-desktop
      docker-compose
      podman-compose
      distrobox
      pciutils
      libmbim
      rquickshare
      sbctl
      trayscale
      usbutils
      cachix
      element-desktop
      jq
      jqp
      p7zip
      uv
      zed-editor
      ddcutil
      ddccontrol
      (python311.withPackages (
        ps: with ps; [
          pynvim
          pip
          debugpy
          impacket
        ]
      ))
    ]
    ++ inputs.qti.packages.${pkgs.system}.qti-all;

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
      configFile = ../katana/kanata.kbd;
      #:: devices = [ ];
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

    };
  };

  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "io.github.zen_browser.zen"
      "org.kiwix.desktop"
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
  ];
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

  system.stateVersion = "24.05"; # "24.05"; # Did you read the comment?

  nix = {
    settings = {

      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 14d";
    # };
  };

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 10";
      flake = "/home/${settings.username}/dots";
    };
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      xorg.libSM
      xorg.libICE
      icu
      libgcc.lib
      e2fsprogs
      libdrm
      mesa
      fontconfig
      freetype
      fribidi
      libgbm
      libGL
      libgpg-error
      harfbuzz
      gcc
      xorg.libX11
      #libX11_xcb
      xorg.libxcb
      zlib
      gvfs # Add gvfs for the missing symbols
      glib # Add glib for GIO-related errors
      xorg.xkbcomp
      #xorg # Add X11 and XKB config
      #stdenv.cc.cc
      #zlib
      #fuse3
      #icu
      #nss
      #openssl
      #curl
      #expat
      # ...
    ];
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
