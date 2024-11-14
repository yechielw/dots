{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    custom.url = "github:yechielw/nixpkgs/master";
    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nixpkgs-howdy.url = "github:fufexan/nixpkgs/howdy";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak"; 




  };

  outputs = { self, nixpkgs, nixpkgs-master, nixos-cosmic, home-manager, lanzaboote, nix-flatpak, custom, ... }@inputs:

  let
    # ...
    system = "x86_64-linux"; # change to whatever your system should be.
    settings = {
      username = "yechiel";
      hostname = "nixos";
    };
 #    pkgs = import nixpkgs {
 #      inherit system;
 #      overlays = [
 #        inputs.hyprpanel.overlay
	# ];
 #      };
    pkgs-master = import nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    custom-packages = import custom {
        inherit system;
        config.allowUnfree = true;
      };
  in
  {
    nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {
          inherit inputs;
          inherit pkgs-master;
          inherit custom-packages;
          inherit settings;

        };
      modules = [
        {
          nix.settings = {
            substituters = [
              "https://cosmic.cachix.org/"
              "https://hyprland.cachix.org"
            ];
            trusted-public-keys = [ 
              "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            ];
          };
        }
        nixos-cosmic.nixosModules.default
        ./configuration.nix
        home-manager.nixosModules.default
        #stylix.nixosModules.stylix
        lanzaboote.nixosModules.lanzaboote
        nix-flatpak.nixosModules.nix-flatpak


      ];
    };
  };
}
