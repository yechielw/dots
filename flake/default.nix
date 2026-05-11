{ inputs, ... }:
{
  imports = [ (inputs.import-tree ./parts) ];

  systems = inputs.nixpkgs.lib.systems.flakeExposed;
}
