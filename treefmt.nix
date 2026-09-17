{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    stylua.enable = true;
    yamlfmt.enable = true;
  };

  # mdsh accepts only one --inputs value, so adapt treefmt's batched arguments.
  settings.formatter.mdsh = {
    command = "${pkgs.bash}/bin/bash";
    options = [
      "-euc"
      ''
        for file in "$@"; do
          ${pkgs.lib.getExe pkgs.mdsh} --inputs "$file"
        done
      ''
      "--"
    ];
    includes = [ "*.md" ];
  };
}
