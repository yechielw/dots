{ inputs, self, ... }:
let
  system = "x86_64-linux";
  specialArgs = import ../lib/special-args.nix { inherit inputs self; };
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  };
in
{
  flake.homeConfigurations.yechiel = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = specialArgs.homeManager;
    modules = [ ../homes/yechiel/default.nix ];
  };
}
