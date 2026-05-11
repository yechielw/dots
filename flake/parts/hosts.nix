{ inputs, self, ... }:
let
  specialArgs = import ../lib/special-args.nix { inherit inputs self; };
in
{
  flake.nixosConfigurations.lenovo-thinkpad-x13 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = specialArgs.nixos;
    modules = [
      ../hosts/lenovo-thinkpad-x13/default.nix
    ];
  };
}
