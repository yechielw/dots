{ pkgs, nixpkgs-master, ... }:

{
  services.intune.enable = true;
  environment.systemPackages = with pkgs; [
    (microsoft-edge.override {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    })
    citrix_workspace
  ];

  nix.settings = {
    substituters = [
      "https://yechielw.cachix.org/"
      "https://ghostty.cachix.org/"
    ];
    trusted-public-keys = [
      "yechielw.cachix.org-1:QTDOxv1zSo70kFYjmifZlZ5329v9QjX7sfpJqwv8h8c="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    ];
  };
}
