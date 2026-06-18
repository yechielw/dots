{ inputs, ... }:
let
  mkAutoPackages = pkgs:
    import ../lib/auto-packages.nix {
      inherit pkgs;
      lib = inputs.nixpkgs.lib;
      packageArgs = inputs;
    };
in
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: _prev: mkAutoPackages final)
        ];
      };
      autoPackages = mkAutoPackages pkgs;
    in
    {
      packages = autoPackages // {
        default = autoPackages.nvim;
      };
    };
}
