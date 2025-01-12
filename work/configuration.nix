{ pkgs, pkgs-master, inputs, custom-packages, settings, ... }:

{
  # custom module with all window  manager stuff
  wm.enable = true;


  services.udev.packages = [ pkgs.via ];

  services.udev.extraRules = ''
    # ACTION=="add", KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users"
  '';

  # services.power-profiles-daemon.enable = false;
  #
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     #USB_AUTOSUSPEND = 0;
  #     USB_EXCLUDE_BTUSB = 1;
  #     USB_EXCLUDE_WWAN = 1;
  #
  #   };
  # };




  networking = {
    hostName = settings.hostname; # Define your hostname.
    #nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
    search = [ "bowfin-marlin.ts.net" ];
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
  services.desktopManager.cosmic.enable = true;
  # nix.settings = {
  # };


  environment.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # hardware.pulseaudio.enable = false;

  hardware.graphics.extraPackages = [ pkgs.intel-compute-runtime ];


  hardware = {
    bluetooth.enable = true;
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
      #(nerdfonts.override { fonts = ["JetBrainsMono" "CascadiaMono"]; })
      nerd-fonts.jetbrains-mono
      #nerd-fonts.cascadia-mono
      corefonts
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
      inputs.monaco.packages.${pkgs.system}.monaco
    ];
    fontconfig.defaultFonts = {
      sansSerif = ["SFProText Nerd Font"];
      monospace = ["JetBrainsMono Nerd Font Mono"];
    };
  };

  environment.pathsToLink = [ "/share/zsh" "/share/qti" ]; # needed for zsh completion declared in zsh config

  environment.systemPackages = with pkgs; [
    alsa-utils
    beeper
    element-desktop
    inputs.ghostty.packages.${pkgs.system}.default
    obsidian
    xxd
    wirelesstools
    qmk via
    bluez-tools
    blueberry
    #espanso-wayland
    nixfmt-rfc-style
    dig
    libmbim
    copyq
    (flameshot.override { enableWlrSupport = true; enableMonochromeIcon = true; } )
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
    jq jqp
    p7zip
    uv
    zed-editor
    ddcutil ddccontrol
    (python311.withPackages(ps: with ps; [
       pynvim
       pip
       debugpy
       impacket
    ]))
  ] ++ inputs.qti.packages.${pkgs.system}.qti-all; 


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.intune.enable = true;
  services.fwupd.enable = true;

  services.fprintd.enable = true;

  services.teamviewer.enable = true;

  
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraSetFlags = [
      "--operator=yechiel"
    ];
    extraUpFlags = [
      "--ssh"

    ];
  };

  
  services.kanata = {

    enable = true;
    keyboards.my = {
      configFile = ../katana/kanata.kbd;
      devices = [];
      #devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];


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
        Context.sockets = ["wayland" "!x11" "!fallback-x11"];

        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "$HOME/.icons";

          # Force correct theme for some GTK apps
          GTK_THEME = "WhiteSur-Dark";
        };
      };


    };
  };

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

  system.stateVersion = "24.05"; #"24.05"; # Did you read the comment?

  nix = {
    settings = { 

      substituters = [
        "https://cosmic.cachix.org/"
      ];
      trusted-public-keys = [ 
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];

      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  programs = {
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
