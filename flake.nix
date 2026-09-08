{
  description = "Nixos config flake";

  nixConfig = { };

  inputs = {

    flake-utils-plus.url = "github:Dines97/flake-utils-plus/aaf79700c35c2f1651843fc70fd104ce85b1171e";

    snowfall-lib = {
      url = "github:anntnzrb/snowfall-lib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
    };

    omniflake = {
      url = "github:yechielw/omniflake/mine";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    beams.url = "github:kleinweb/beams";
    beams.inputs.nixpkgs.follows = "nixpkgs";

    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    raise.url = "github:yechielw/raise";
    raise.inputs.nixpkgs.follows = "nixpkgs";

    profilepic = {
      url = "https://github.com/yechielw.png";
      flake = false;
    };
  };
  outputs = inputs: import ./outputs.nix inputs;
}
