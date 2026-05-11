{ inputs, self, ... }:
let
  system = "x86_64-linux";
  specialArgs = import ../lib/special-args.nix { inherit inputs self; };
in
{
  flake.homeConfigurations.yechiel = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    extraSpecialArgs = specialArgs.homeManager;
    modules = [ ../homes/yechiel/default.nix ];
  };
}
