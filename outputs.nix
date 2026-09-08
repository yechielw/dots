inputs:
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

    systems.modules.nixos = [
      inputs.omniflake.pinned.determinate.nixosModules.default
      inputs.omniflake.pinned.nix-flatpak.nixosModules.nix-flatpak
      inputs.omniflake.pinned.vicinae.nixosModules.default
      inputs.omniflake.pinned.lanzaboote.nixosModules.lanzaboote
      inputs.omniflake.pinned.nyx.nixosModules.default
      inputs.omniflake.pinned.dankmaterialshell.nixosModules.default
    ];
    homes.modules = [
      inputs.omniflake.pinned.vicinae.homeManagerModules.default
    ];

    channels.master.input = inputs.omniflake.pinned.nixpkgs;

    channels-config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };

    outputs-builder = channels: {
      formatter = channels.nixpkgs.nixpkgs-fmt;
    };
  };
in
base.lib.exposeAvailableModules base
