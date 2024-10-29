{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    stylix.url = "github:danth/stylix";
    nixpkgs-howdy.url = "github:fufexan/nixpkgs/howdy";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };



  };

  outputs = { self, nixpkgs, nixpkgs-master, nixos-cosmic, home-manager, stylix, lanzaboote, ... }@inputs:

  let
    # ...
    system = "x86_64-linux"; # change to whatever your system should be.
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
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
          inherit inputs;
          inherit pkgs-master;
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

      ];
    };
  };
}
