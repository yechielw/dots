{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) hasPrefix hasSuffix mapAttrsToList removeSuffix;

  mkModuleTree =
    dir:
    let
      children = builtins.readDir dir;
      names = builtins.attrNames children;
      filtered =
        builtins.filter
          (name:
            let
              kind = children.${name};
            in
            !hasPrefix "_" name
            && (
              kind == "directory"
              || (kind == "regular" && hasSuffix ".nix" name)
            )
          )
          names;
    in
    builtins.listToAttrs (
      map
        (
          name:
          let
            kind = children.${name};
            path = "${dir}/${name}";
          in
          if kind == "directory" then
            {
              inherit name;
              value = mkModuleTree path;
            }
          else
            {
              name = removeSuffix ".nix" name;
              value = import path;
            }
        )
        filtered
    );

  nixosModuleTree = mkModuleTree ../modules/nixos;
  homeModuleTree = mkModuleTree ../modules/home;
in
{
  flake = {
    nixosModules = nixosModuleTree // { all = inputs.import-tree ../modules/nixos; };
    homeManagerModules = homeModuleTree // { all = inputs.import-tree ../modules/home; };
    formatter = {
      x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
  };
}
