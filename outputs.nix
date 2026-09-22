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

    outputs-builder =
      channels:
      let
        treefmt = inputs.omniflake.flakes.treefmt-nix.lib.evalModule channels.nixpkgs ./treefmt.nix;
      in
      {
        formatter = treefmt.config.build.wrapper;
        checks.treefmt = treefmt.config.build.check inputs.self;
      };
  };
in
base.lib.exposeAvailableModules base
