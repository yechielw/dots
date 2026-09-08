{ inputs, pkgs, ... }:
inputs.omniflake.pinned.nix-wrapper-modules.lib.evalPackage [
  ./module.nix
  { inherit pkgs; }
]
