{
  pkgs,
  inputs,
  config,
  ...
}:

{

  programs.evolution.enable = true;
  programs.evolution.plugins = [ pkgs.evolution-ews ];

  services.intune.enable = true;
  environment.systemPackages = with pkgs; [
    #    citrix_workspace
    microsoft-edge

  ];

  imports = [ inputs.himmelblau.nixosModules.himmelblau ];
  services.himmelblau = {
    enable = false;
    # debugFlag = true;
    domains = [ "mac.org.il" ];
    settings = {
      pam_allow_groups = [ ];
      join_type = "register";

      local_groups = config.users.users.yechiel.extraGroups;
    };
  };

  nix.settings = {
    substituters = [
      "https://yechielw.cachix.org/"
      #"https://ghostty.cachix.org/"
    ];
    trusted-public-keys = [
      "yechielw.cachix.org-1:QTDOxv1zSo70kFYjmifZlZ5329v9QjX7sfpJqwv8h8c="
      #"ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    ];
  };
}
