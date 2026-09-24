{
  description = "Nixos config flake";

  nixConfig = { };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*";

    # temp bug patches

    omniflake = {
      url = "github:fzakaria/omniflake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils-plus.url = "github:Dines97/flake-utils-plus";

    snowfall-lib = {
      url = "github:anntnzrb/snowfall-lib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # end of temp bug fixes

    profilepic = {
      url = "https://github.com/yechielw.png";
      flake = false;
    };
  };
  outputs =
    inputs:
    import ./outputs.nix (
      inputs
      // {
        home-manager = inputs.omniflake.flakes.home-manager;
      }
    );
}
