{
  config,
  pkgs,
  settings,
  inputs,
  impurity,
  ...
}:
{

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bckup";
    extraSpecialArgs = {
      inherit inputs;
      inherit settings;
      inherit impurity;
    };
    users = {
      "${settings.username}" = import ./work/home/home.nix;
    };
  };
}
