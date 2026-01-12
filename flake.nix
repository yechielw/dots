{
  description = "Nixos config flake";

  outputs =
    {
      nixpkgs,
      nixpkgs-master,
      nixpkgs-stable,
      home-manager,
      self,
      # profilepic,
      nixCats,
      ...
    }@inputs:
    let
      # This let block is for your system-specific NixOS configuration
      system = "x86_64-linux";
      settings = import ./nix/settings.nix;
      config.allowUnfree = true;
      pkgs-master = import nixpkgs-master {
        inherit system;
        inherit config;
      };
      stable = import nixpkgs-stable {
        inherit system;
        inherit config;
      };
      mkPackagesFor = import ./nix/modules/nixcats.nix inputs;
      eachSystem = nixCats.utils.eachSystem nixpkgs.lib.systems.flakeExposed;
    in
    eachSystem mkPackagesFor

    // {

      homeManagerModules.tui = ./nix/modules/tui/hm.nix;
      homeManagerModules.gui = ./nix/modules/wm.nix;

      homeConfigurations.yechiel = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./nix/modules/tui/hm.nix
          {
            hm.tui.enable = true;
            home.stateVersion = "25.05";
            home.username = "test";
            home.homeDirectory = "/tmp/home";
          }
        ];
      };

      nixosConfigurations = {
        lenovo-thinkpad-x13 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit stable;
            inherit pkgs-master;
            inherit settings;
            inherit self;
          };
          modules = [
            ./nix/hosts/lenovo-thinkpad-x13.nix
          ];
        };
      };
    };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:yechielw/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    howdy-module.url = "github:pineapplehunter/howdy-module";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    burpsuite.url = "github:yechielw/burpsuite.nix";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    raise.url = "github:knarkzel/raise";
    raise.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
    vicinae.url = "github:vicinaehq/vicinae?tag=releases/latest";

    himmelblau.url = "github:himmelblau-idm/himmelblau";
    himmelblau.inputs.nixpkgs.follows = "nixpkgs";

    profilepic = {
      url = "https://github.com/yechielw.png";
      flake = false;
    };
  };
}
