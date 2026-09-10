{
  inputs,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  git-hooks = inputs.self.checks.${system}.git-hooks;
in
pkgs.mkShellNoCC {
  packages = git-hooks.enabledPackages;
  inherit (git-hooks) shellHook;
}
