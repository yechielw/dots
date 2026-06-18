{
  lib,
  pkgs,
  directory ? ../packages,
  packageArgs ? { },
  ignoredPackageNames ? [ ],
}:

lib.removeAttrs
  (lib.filesystem.packagesFromDirectoryRecursive {
    directory = lib.cleanSourceWith {
      src = directory;
      filter = _path: type: type != "symlink";
    };
    callPackage =
      path: overrides:
      let
        functionArgs = builtins.functionArgs (import path);
        acceptedPackageArgs = lib.filterAttrs (name: _value: functionArgs ? ${name}) packageArgs;
      in
      pkgs.callPackage path (acceptedPackageArgs // overrides);
  })
  ignoredPackageNames
