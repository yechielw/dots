{
  description = "Nixos config flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    hyprland.url = "github:hyprwm/Hyprland";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nyx-loner.url = "github:lonerOrz/nyx-loner";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    lanzaboote.url = "github:nix-community/lanzaboote";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    burpsuite.url = "github:yechielw/burpsuite.nix";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    raise.url = "github:knarkzel/raise";
    raise.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
    vicinae.url = "github:vicinaehq/vicinae"; # ?tag=releases/latest";
    icalindicator.url = "github:yechielw/icalindicator";

    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    #himmelblau.url = "github:himmelblau-idm/himmelblau";
    #himmelblau.inputs.nixpkgs.follows = "nixpkgs";

    profilepic = {
      url = "https://github.com/yechielw.png";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./flake/default.nix ];
    };
}
