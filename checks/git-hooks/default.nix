{
  inputs,
  pkgs,
  ...
}:

let
  git-hooks = inputs.omniflake.flakes."github:cachix/git-hooks.nix";
  system = pkgs.stdenv.hostPlatform.system;
in
git-hooks.lib.${system}.run {
  src = ../../.;
  package = pkgs.prek;

  hooks = {
    statix.enable = true;
    deadnix.enable = true;

    treefmt = {
      enable = true;
      package = inputs.self.formatter.${system};
    };

    shellcheck.enable = true;
    trufflehog.enable = true;
  };
}
