{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.icalindicator.homeManagerModules.default
  ];

  home.stateVersion = "25.05";
  home.username = "yechiel";
  # home.homeDirectory = lib.mkForce "/home/yechiel";
}
