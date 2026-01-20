{
  pkgs,
  howdy-pr,
  ...
}: let
  # Access the specific package set from the PR input
  prPkgs = howdy-pr.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # 1. Import the module logic from the PR files
  imports = [
    "${howdy-pr}/nixos/modules/services/security/howdy/default.nix"
    "${howdy-pr}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
    "${howdy-pr}/nixos/modules/security/pam.nix"
  ];
  disabledModules = ["security/pam.nix"];

  # 3. Optional: Add the helper tools to your shell path
  environment.systemPackages = [
    prPkgs.howdy
    prPkgs.linux-enable-ir-emitter
  ];
  security.pam.howdy = {
    enable = true;
    control = "sufficient";
  };
}
