{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    microsoft-edge
    citrix_workspace
  ];
}
