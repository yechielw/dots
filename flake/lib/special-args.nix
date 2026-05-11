{ inputs, self }:
let
  system = "x86_64-linux";
  pkgsSets = import ./pkgs-sets.nix {
    inherit inputs system;
  };
in
{
  nixos = {
    inherit inputs self;
    inherit (pkgsSets) pkgs-master stable;
  };
  homeManager = {
    inherit inputs self;
    inherit (pkgsSets) pkgs-master stable;
  };
}
