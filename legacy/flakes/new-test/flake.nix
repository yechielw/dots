{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    lanzaboote.url = "github:nix-community/lanzaboote";


  };

  outputs = { self, nixpkgs, nixos-cosmic, home-manager, ... }@inputs:

  let
    # ...
	  system = "x86_64-linux"; # change to whatever your system should be.
    pkgs = import nixpkgs {
	    inherit system;
	    overlays = [
        inputs.hyprpanel.overlay
	    ];
	  };
  in
  {
    nixosConfigurations.nixos-toshiba = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
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
      ];
    };
  };
}
