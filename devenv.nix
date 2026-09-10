{ pkgs, ... }:

{
  git-hooks.hooks = {
    # nixmft.enable = true;
    statix.enable = true;
    deadnix.enable = true;
    treefmt = {
      enable = true;
      settings.formatters = [
        pkgs.nixfmt
      ];
    };

    shellcheck.enable = true;

    stylua.enable = true;

    # flake-checker.enable = true;
    yamlfmt.enable = true;
    mdsh.enable = true;

    trufflehog.enable = true;
    zizmor.enable = false;
  };
  git-hooks.package = pkgs.prek;
}
