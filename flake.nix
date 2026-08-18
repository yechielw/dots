{
  description = "Nixos config flake";

  nixConfig = {
  };

  inputs = {
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
    nixpkgs.url = "nixpkgs/nixos-unstable";
    stable.url = "nixpkgs/nixos-25.05";
    master.url = "nixpkgs/master";

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
    # dms.url = "github:yechielw/DankMaterialShell/cell";
    dms.url = "github:kmf/DankMaterialShell/pr-2765-cellular-rebase";
    # dms.url = "git+file:///home/yechiel/tools/DankMaterialShell";
    wrappers.url = "github:lassulus/wrappers";
    bw.url = "github:BirdeeHub/nix-wrapper-modules";

    plugins-lze = {
      url = "github:BirdeeHub/lze";
      flake = false;
    };
    # These 2 are already in nixpkgs, however this ensures you always fetch the most up to date version!
    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };

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
  outputs = inputs: import ./outputs.nix inputs;
  # outputs =
  #   inputs:
  #   let
  #     base = inputs.snowfall-lib.mkFlake {
  #       inherit inputs;
  #       src = ./.;
  #
  #       supportedSystems = [
  #         "x86_64-linux"
  #         "aarch64-linux"
  #         "aarch64-darwin"
  #       ];
  #
  #       snowfall = {
  #         namespace = "yechiel";
  #         meta = {
  #           name = "dots";
  #           title = "Yechiel's NixOS configuration";
  #         };
  #       };
  #
  #       systems.modules.nixos = with inputs; [
  #         determinate.nixosModules.default
  #         nix-flatpak.nixosModules.nix-flatpak
  #         vicinae.nixosModules.default
  #         lanzaboote.nixosModules.lanzaboote
  #         chaotic.nixosModules.default
  #         dms.nixosModules.default
  #       ];
  #       homes.modules = with inputs; [
  #         vicinae.homeManagerModules.default
  #       ];
  #
  #       channels-config = {
  #         allowUnfree = true;
  #         android_sdk.accept_license = true;
  #       };
  #
  #       outputs-builder = channels: {
  #         formatter = channels.nixpkgs.nixpkgs-fmt;
  #       };
  #     };
  #   in
  #   base.lib.exposeAvailableModules base;
}
