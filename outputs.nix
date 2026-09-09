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

    channels.master.input = inputs.omniflake.flakes.nixpkgs;

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
