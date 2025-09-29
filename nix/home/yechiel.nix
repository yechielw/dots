{
  pkgs,
  inputs,
  settings,
  pkgs-master,
  self,
  ...
}:

{

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bck";
    extraSpecialArgs = {
      inherit inputs;
      inherit settings;
      inherit self;
      inherit pkgs-master;
    };
    users = {
      yechiel = {
        imports = [
          inputs.vicinae.homeManagerModules.default
          #inputs.batt.homeManagerModules.default

          ../../nix/modules/wm.nix
          ../../nix/modules/apearance/hm.nix
          ../../nix/modules/tui/hm.nix
          ../../nix/modules/hypr.nix
          ./homeconfig.nix
        ];
      };
    };
  };
}
