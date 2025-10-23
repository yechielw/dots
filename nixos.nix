{inputs, ...}:

let
  settings = import ./nix/settings.nix;
  config.allowUnfree = true;
  pkgs-master = import nixpkgs-master {
    inherit config;
  };
  stable = import nixpkgs-stable {
    inherit config;
  };
in
{
  flake = {
    nixosConfigurations = {
      lenovo-thinkpad-x13 = inputs.nixpkgs.lib.nixosSystem {
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
  }
}
