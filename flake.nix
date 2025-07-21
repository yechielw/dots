{
  description = "Nixos config flake";

  outputs =
    {
      nixpkgs,
      nixpkgs-master,
      nixpkgs-stable,
      home-manager,
      self,
      profilepic,
      cats,
      ...
    }@inputs:
    let
      #system = "x86_64-linux";
      settings = import ./nix/settings.nix;
      system = "${settings.system}";
      pkgs-master = import nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nvim = inputs.cats.packages.${system}.default;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit stable;
            inherit pkgs-master;
            #inherit custom-packages
            inherit settings;
            inherit profilepic;
            inherit cats;
          };
          modules = [

            #nixos-cosmic.nixosModules.default
            home-manager.nixosModules.default
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.espanso-fix.nixosModules.espanso-capdacoverride
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13
            inputs.determinate.nixosModules.default
            #inputs.impurity.nixosModules.impurity
            inputs.howdy-module.nixosModules.default
            inputs.burpsuite.nixosModules.default

            {
              services.howdy.enable = true;
              services.howdy.settings.video.dark_threshold = 80;
              environment.sessionVariables.OMP_NUM_THREADS = 1;
              services.linux-enable-ir-emitter.enable = true;
              impurity.configRoot = self;
              impurity.enable = true;

            }

            ./nix/configuration.nix
            ./nix/packages.nix
            #./nix/users.nix
            ./nix/hardware-configuration.nix
            #./nix/settings.nix
            ./nix/hacking.nix
            ./nix/work.nix
            ./nix/term.nix
            ./nix/wm.nix
            ./nix/vm.nix
            ./nix/boot.nix
            ./nix/override.nix
            ./users/yechiel/home/home.nix
            #./nix/howdy.nix
            #./nix/cosmic.nix
            ./modules/impurity
          ];
        };
        testing = self.nixosConfigurations.nixos.extendModules {
          modules = [ { impurity.enable = true; } ];
        };
      };
    };
  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
    burpsuite.url = "github:yechielw/burpsuite.nix";
    ghostty.url = "github:ghostty-org/ghostty";
    cats.url = "./config/nixcats";
    profilepic = {
      url = "https://github.com/yechielw.png";
      flake = false;
    };
  };
}
