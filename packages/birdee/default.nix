{ inputs, pkgs, ... }:
inputs.bw.lib.evalPackage [
  ./module.nix
  { inherit pkgs; }
]
