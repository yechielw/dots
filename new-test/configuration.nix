{ config, lib, pkgs, inputs, ... }:




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
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;

  # nvidia stuuf for wayland
  boot.kernelParams = [ "nvidia_drm.fbdev=1" "quiet"];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    xkb.options = "grp:win_space_toggle";
};

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
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
  security.pki.certificateFiles = [
  ../certs/netspark.pem
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yechiel = {
    isNormalUser = true;
    description = "Yechiel Worenklein";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "yechiel";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.

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
  ];
  environment.systemPackages = with pkgs; [
    (burpsuite.override { proEdition = true; })
    #(nerdfonts.override { fonts = ["JetBrainsMono" "CascadiaMono"]; })
    gnomeExtensions.pop-shell
    ags
    atuin
    bat
    bloodhound-py
    caido
    citrix_workspace
    curl
    eza  
    fd
    fzf
    gcc
    git
    go
    google-chrome
    gzip
    kitty
    microsoft-edge
    neovim
    netexec
    nodejs
    pipx
    pyenv
    ripgrep
    thunderbird
    unetbootin
    unzip
    wget
    zoxide
    zsh
    (python311.withPackages(ps: with ps; [
       pynvim
       pip
       debugpy
       impacket
    ]))
  ]; 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.intune.enable = true;
  services.flatpak.enable = true;




  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; #"24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs = {
    zsh.enable = true;
    firefox.enable = true; # left becaus its default
    #kitty.enable = true;    # required for the default Hyprland config
    hyprland.enable = true; # enable Hyprland
  };
  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "yechiel" = import ./home-new.nix;
    };
  };


}
