{ lib, ... }:
{
  imports = with lib.yechiel.nixos; [ test ];
}
