{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib)
    hasPrefix
    hasSuffix
    mapAttrsToList
    removeSuffix
    ;

  mkModuleTree =
    dir:
    let
      children = builtins.readDir dir;
      names = builtins.attrNames children;
      filtered = builtins.filter (
        name:
        let
          kind = children.${name};
        in
        !hasPrefix "_" name && (kind == "directory" || (kind == "regular" && hasSuffix ".nix" name))
      ) names;
    in
    builtins.listToAttrs (
      map (
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
      ) filtered
    );

  nixosModuleTree = mkModuleTree ../modules/nixos;
  homeModuleTree = mkModuleTree ../modules/home;
  mkAutoPackages = pkgs:
    import ../lib/auto-packages.nix {
      inherit pkgs;
      lib = inputs.nixpkgs.lib;
      packageArgs = inputs;
    };
in
{
  flake = {
    overlays.default = final: _prev: mkAutoPackages final;

    nixosModules = nixosModuleTree // {
      all = {
        imports = [
          ../modules/nixos/profiles/base.nix
          ../modules/nixos/profiles/desktop.nix
          ../modules/nixos/profiles/tui.nix
          ../modules/nixos/profiles/development.nix
          ../modules/nixos/profiles/cyber.nix
          ../modules/nixos/profiles/virtualization.nix
          ../modules/nixos/profiles/work.nix
          ../modules/nixos/profiles/laptop.nix
        ];
      };
    };
    homeManagerModules = homeModuleTree // {
      all = {
        imports = [
          ../modules/home/profiles/base.nix
          ../modules/home/profiles/desktop.nix
          ../modules/home/profiles/development.nix
          ../modules/home/profiles/tui.nix
        ];
      };
    };
    formatter = {
      x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
  };
}
