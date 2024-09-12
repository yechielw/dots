
{
  description = "My first System + Home-manager flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
      };
    };

      homeConfigurations = {
        yechiel = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          modules = [ ./home.nix ];
      };
    };
  };
}
