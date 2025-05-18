{ config, pkgs, ... }:

{
  programs.oh-my-posh = {
    enable = true;
    # overrideAttrs accepts the old attrs attrset
    package = pkgs.oh-my-posh.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        # if your patch is local:

        # or if it’s remote:
        (pkgs.fetchurl {
          url = "https://github.com/nix-community/home-manager/pull/6108.patch";
          hash = "sha256-…";
        })
      ];
    });
  };
}
