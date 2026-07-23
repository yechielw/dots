{ lib, ... }:
{
  # A bare username applies to every host on this target system.
  imports = with lib.yechiel.home; [
    desktop
    shell
  ];

  home.stateVersion = "25.05";
}
