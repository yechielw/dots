{
  description = "Nixos config flake";

  inputs = {
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/*";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
    # vicinae.url = "github:yechielw/vicinae/chrome-integration-2"; # ?tag=releases/latest";

    # dms.url = "github:AvengeMedia/DankMaterialShell";
    dms.url = "github:yechielw/DankMaterialShell/cell";
    # dms.url = "git+file:///home/yechiel/tools/DankMaterialShell";
    wrappers.url = "github:lassulus/wrappers";
    bw.url = "github:BirdeeHub/nix-wrapper-modules";
    herdr.url = "github:ogulcancelik/herdr";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    profilepic = {
      url = "https://github.com/yechielw.png";
      flake = false;
    };
  };

  outputs = inputs:
    let
      base = inputs.snowfall-lib.mkFlake {
        inherit inputs;
        src = ./.;

        supportedSystems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];

        snowfall = {
          namespace = "yechiel";
          meta = {
            name = "dots";
            title = "Yechiel's NixOS configuration";
          };
        };

        channels-config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };

        outputs-builder = channels: {
          formatter = channels.nixpkgs.nixpkgs-fmt;
        };
      };
    in
    base.lib.exposeAvailableModules base;
}
