{
  inputs,
  ...
}:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.icalindicator.homeManagerModules.default

    ../../modules/home/profiles/base.nix
    ../../modules/home/profiles/desktop.nix
    ../../modules/home/profiles/development.nix
    ../../modules/home/profiles/tui.nix
  ];

  home.stateVersion = "25.05";
  home.username = "yechiel";
  home.homeDirectory = "/tmp/home";
}
