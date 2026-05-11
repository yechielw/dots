{ inputs, ... }:
let
  mkPackagesFor = import ../packages/nixcats.nix inputs;
in
{
  perSystem = { system, ... }: mkPackagesFor system;
}
