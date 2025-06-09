{
  description = "Nixos config flake";

  outputs =
    {
      nixpkgs,
      nixpkgs-master,
      home-manager,
      ...
    }@inputs:
    let
      #system = "x86_64-linux";
      settings = import ./work/settings.nix;
      system = "${settings.system}";
      pkgs-master = import nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-master;
          #inherit custom-packages
          inherit settings;
        };
        modules = [

          #nixos-cosmic.nixosModules.default
          home-manager.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.espanso-fix.nixosModules.espanso-capdacoverride
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13
          inputs.determinate.nixosModules.default
          inputs.howdy-module.nixosModules.default

          {
            services.howdy.enable = true;
            services.howdy.settings.video.dark_threshold = 80;
            services.linux-enable-ir-emitter.enable = true;
          }

          ./work/configuration.nix
          ./work/users.nix
          ./work/hardware-configuration.nix
          #./work/settings.nix
          ./work/hacking.nix
          ./work/work.nix
          ./work/term.nix
          ./work/wm.nix
          ./work/vm.nix
          ./work/boot.nix
          ./work/override.nix
          ./home.nix
          #./work/howdy.nix
          #./work/cosmic.nix
        ];
      };
    };
  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:yechielw/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    hyprland.url = "github:hyprwm/Hyprland";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    howdy-module.url = "github:pineapplehunter/howdy-module";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";

    walker.url = "github:abenz1267/walker";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };
}
