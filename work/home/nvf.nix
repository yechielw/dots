{
  pkgs,
  inputs,
  settings,
  ...
}:
{

  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    settings = { };
  };
}
