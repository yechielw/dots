{
  pkgs,
  inputs,
  ...
}:

{
  disabledModules = [ "security/pam.nix" ];
  imports = [
    "${inputs.nixpkgs-howdy}/nixos/modules/security/pam.nix"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/security/howdy"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
  ];
  services = {
    howdy = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
      # settings = {
      #   core = {
      #     abort_if_ssh = true;
      #   };
      #   video.dark_threshold = 90;
      #   video.timeout = 2;
      # };
    };

    linux-enable-ir-emitter = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    };
  };
  security.pam.services.howdy.enable = true;

}
