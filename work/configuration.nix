{ pkgs, pkgs-master, inputs, custom-packages, ... }:




let
  msIDBrokerHash = final: prev: {
    microsoft-identity-broker = prev.microsoft-identity-broker.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = oldAttrs.src.url;  # Keep the same URL
        sha256 = "I4Q6ucT6ps8/QGiQTNbMXcKxq6UMcuwJ0Prcqvov56M=";  # Update with the new hash
      };
    });
  };
in

{

  # Your other NixOS configurations go here




  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hacking.nix
      ./work.nix
      ./term.nix
      ./wm.nix
      ./vm.nix
      inputs.home-manager.nixosModules.default


      # "${inputs.nixpkgs-howdy}/nixos/modules/security/pam.nix"
      # "${inputs.nixpkgs-howdy}/nixos/modules/services/security/howdy"
      # "${inputs.nixpkgs-howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"

    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  
  #zramSwap.enable = true;

  # nvidia stuuf for wayland
  #boot.kernelParams = [ "quiet"];
  #boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = [ "i2c-dev" ]; #"ddcci_backlight"];
  services.udev.extraRules = ''KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"'';

  boot.initrd.luks.devices."luks-1bb11aec-2423-4bf5-85cc-a16c268cc233".device = "/dev/disk/by-uuid/1bb11aec-2423-4bf5-85cc-a16c268cc233";
  networking.hostName = "nixos"; # Define your hostname.
  #networking.nameservers = [ "100.100.100.100" "192.168.122.1" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "bowfin-marlin.ts.net" ];
  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us,il";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.cosmic.enable = true;
    environment.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    COSMIC_DATA_CONTROL_ENABLED = 1;
  };
  systemd.tmpfiles.rules = [
    "L /usr/share/X11/xkb/rules/base.xml - - - - ${pkgs.xkeyboard_config}/share/X11/xkb/rules/base.xml"
  ];

  #services.displayManager.cosmic-greeter.enable = true;
  # Configure keymap in X11
    #services.xserver.xkb = {
    #layout = "us";
    #variant = "";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pki.certificateFiles = [
    ../certs/netspark.pem
    ../certs/burp.pem
];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.pipewire.wireplumber.enable = true;


  users.users.yechiel = {
    isNormalUser = true;
    description = "Yechiel Worenklein";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "i2c"];
  };


  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      };
    overlays = [ msIDBrokerHash ];
    };

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["JetBrainsMono" "CascadiaMono"]; })
    corefonts
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
  ];
  environment.systemPackages = with pkgs; [
    (custom-packages.burpsuite.override { proEdition = true; })
    dig
    libmbim
    copyq
    (flameshot.override { enableWlrSupport = true; enableMonochromeIcon = true; } )
    #ags
    curl
    gcc
    git
    go
    google-chrome
    gzip
    kitty
    neovim
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
    albert
    hyprlock
    libmbim
    rquickshare
    sbctl
    trayscale
    usbutils
    ddcutil ddccontrol
    (python311.withPackages(ps: with ps; [
       pynvim
       pip
       debugpy
       impacket
    ]))
  ]; 


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.intune.enable = true;

  services.fprintd.enable = true;

  services.teamviewer.enable = true;

  services.blueman.enable = true;
  services.tailscale.enable = true;


  services.flatpak.enable = true;

  services.flatpak.packages = [
    "com.usebottles.bottles"
  ];
  
  # disabledModules = ["security/pam.nix"];
    
  # services = {
  #   howdy = {
  #     enable = true;
  #     package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
  #     settings = {
  #       video.device_path = "/dev/video2";
  #       # you may not need these
  #       #core.no_confirmation = true;
  #       video.dark_threshold = 100;
  #     };
  #   };
  #
  #   # in case your IR blaster does not blink, run `sudo linux-enable-ir-emitter configure`
  #   linux-enable-ir-emitter = {
  #     enable = true;
  #     package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
  #   };
  # };


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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs = {
    zsh.enable = true;
    firefox.enable = true; # left becaus its default
    #kitty.enable = true;    # required for the default Hyprland config
    hyprland.enable = true; # enable Hyprland
    #    kdeconnect.enable = true;
    java.enable = true;

  };
  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    extraSpecialArgs = {
      inherit inputs; 
      inherit custom-packages;
    };
    backupFileExtension = "hm-bck";
    users = {
      "yechiel" = import ./home/home.nix;
    };
  };

  #virtualisation.libvirtd.enable = true;
  #programs.virt-manager.enable = true;

  virtualisation.containers.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

}
