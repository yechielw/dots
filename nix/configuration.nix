{
  pkgs,
  inputs,
  ...
}:

{
  # custom module with all window  manager stuff
  wm.enable = true;
  hacking.enable = true;
  # imports = [ inputs.stylix.nixosModules.stylix ];
  # stylix.enable = true;
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

  networking = {
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
        80
        4444
        46387
      ];
    };
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    # extraLocaleSettings = {
    #   LC_ADDRESS = "en_US.UTF-8";
    #   LC_IDENTIFICATION = "en_US.UTF-8";
    #   LC_MEASUREMENT = "en_US.UTF-8";
    #   LC_MONETARY = "en_US.UTF-8";
    #   LC_NAME = "en_US.UTF-8";
    #   LC_NUMERIC = "en_US.UTF-8";
    #   LC_PAPER = "en_US.UTF-8";
    #   LC_TELEPHONE = "en_US.UTF-8";
    #   LC_TIME = "en_US.UTF-8";
    # };
  };

  # Enable the X11 windowing system.

  environment.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  # Enable CUPS to print documents.

  hardware.i2c.enable = true;
  hardware.keyboard.qmk.enable = true;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pki.certificateFiles = pkgs.lib.filesystem.listFilesRecursive ../config/certs;

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
    "/share/icons"
    "/share/pixmaps"
  ]; # needed for zsh completion declared in zsh config

  # Enable the OpenSSH daemon.

  systemd.tmpfiles.rules = [
    "L /usr/share/X11/xkb/rules/base.xml - - - - ${pkgs.xkeyboard_config}/share/X11/xkb/rules/base.xml"
    "L /var/lib/AccountsService/icons/yechiel - - - - ${inputs.profilepic}"
  ];

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

  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      android_sdk.accept_license = true;
    };
  };

  users.defaultUserShell = pkgs.zsh;
}
