{pkgs,nixpkgs-master, ...}:

{
  environment.systemPackages = with pkgs; [
    (microsoft-edge.override { commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland"; } )
    #pkgs-master.citrix_workspace_24_05_0
  ];

  nix.settings = {
    substituters = [
      "https://yechielw.cachix.org/"
    ];
    trusted-public-keys = [ 
      "yechielw.cachix.org-1:QTDOxv1zSo70kFYjmifZlZ5329v9QjX7sfpJqwv8h8c="
    ];
  };
}
