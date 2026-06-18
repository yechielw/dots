{ lib, ... }:
{
  home = {
    username = lib.mkDefault "yechiel";
    homeDirectory = lib.mkDefault "/home/yechiel";
    stateVersion = lib.mkDefault "24.05";
  };

  programs.home-manager.enable = true;
}
