{ lib, ... }:
let
  availableModulesRoot = lib.snowfall.fs.get-snowfall-file "modules/available";
  discoverModules =
    type:
    lib.snowfall.module.create-modules {
      src = "${availableModulesRoot}/${type}";
    };
  modules = {
    nixos = discoverModules "nixos";
    darwin = discoverModules "darwin";
    home = discoverModules "home";
  };
  exposeAvailableModules =
    outputs:
    outputs
    // {
      nixosModules = (outputs.nixosModules or { }) // modules.nixos;
      darwinModules = (outputs.darwinModules or { }) // modules.darwin;
      homeModules = (outputs.homeModules or { }) // modules.home;
    };
in
{
  inherit exposeAvailableModules;
  inherit (modules) nixos darwin home;
}
