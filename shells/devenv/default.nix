{
  pkgs,
  inputs,
  ...
}:
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [
    (
      { pkgs, ... }:
      {
        devenv.root = "/home/yechiel/dots";
        git-hooks.hooks = {
          nixfmt.enable = true;

          shellcheck.enable = true;

          stylua.enable = true;

          flake-checker.enable = true;
          yamlfmt.enable = true;
          mdsh.enable = true;

          trufflehog.enable = true;
          zizmor.enable = false;
        };

        git-hooks.package = pkgs.prek;
      }
    )
  ];
}
