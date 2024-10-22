{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    (microsoft-edge.override { commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland"; } )
    citrix_workspace
  ];
}
