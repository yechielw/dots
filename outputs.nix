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

    systems.modules.nixos = with inputs; [
      determinate.nixosModules.default
      nix-flatpak.nixosModules.nix-flatpak
      vicinae.nixosModules.default
      lanzaboote.nixosModules.lanzaboote
      chaotic.nixosModules.default
      dms.nixosModules.default
    ];
    homes.modules = with inputs; [
      vicinae.homeManagerModules.default
    ];

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
