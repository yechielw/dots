{
  config,
  pkgs,
  settings,
  inputs,
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
    };
    users = {
      "${settings.username}" = import ./work/home/home.nix;
    };
  };
}
