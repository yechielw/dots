{pkgs,nixpkgs-master, ...}:

{
  environment.systemPackages = with pkgs; [
    (microsoft-edge.override { commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland"; } )
    #pkgs-master.citrix_workspace
  ];
}
