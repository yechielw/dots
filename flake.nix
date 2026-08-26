{
  description = "Nixos config flake";

  nixConfig = {
  };

  inputs = {

    cx-ast.url = "github:yechielw/cx-ast.nvim";
    flake-utils-plus.url = "github:Dines97/flake-utils-plus/aaf79700c35c2f1651843fc70fd104ce85b1171e";

    snowfall-lib = {
      url = "github:anntnzrb/snowfall-lib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    beams.url = "github:kleinweb/beams";
    beams.inputs.nixpkgs.follows = "nixpkgs";
    beams.inputs.pre-commit-hooks.follows = "pre-commit-hooks";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # IMPORTANT

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    lanzaboote.url = "github:nix-community/lanzaboote";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    burpsuite.url = "github:yechielw/burpsuite.nix";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    raise.url = "github:yechielw/raise";
    raise.inputs.nixpkgs.follows = "nixpkgs";
    vicinae.url = "github:vicinaehq/vicinae"; # ?tag=releases/latest";

    dms.url = "github:AvengeMedia/DankMaterialShell";
    # dms.url = "github:yechielw/DankMaterialShell/cell";
    wrappers.url = "github:lassulus/wrappers";
    bw.url = "github:BirdeeHub/nix-wrapper-modules";

    # herdr.url = "github:ogulcancelik/herdr";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    profilepic = {
      url = "https://github.com/yechielw.png";
      flake = false;
    };
    lerd = {
      url = "github:lerd-env/lerd-nixos";
      # Build lerd against your own nixpkgs instead of the one it pins,
      # so you don't download a second copy of nixpkgs:
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: import ./outputs.nix inputs;
}
