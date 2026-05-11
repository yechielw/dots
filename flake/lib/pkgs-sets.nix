{
  inputs,
  system,
}:
let
  nixpkgsConfig = {
    allowUnfree = true;
  };
  pkgs-master = import inputs.nixpkgs-master {
    inherit system;
    config = nixpkgsConfig;
  };
  stable = import inputs.nixpkgs-stable {
    inherit system;
    config = nixpkgsConfig;
  };
in
{
  inherit nixpkgsConfig pkgs-master stable;
}
