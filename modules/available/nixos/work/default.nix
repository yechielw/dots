{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.beams.modules.nixos.citrix-secure-access ];
  services.citrix-secure-access.enable = true;

  programs.evolution.enable = true;
  programs.evolution.plugins = [ pkgs.evolution-ews ];

  # services.citrix-secure-access.enable = true;
  services.intune.enable = true;

  environment.systemPackages = with pkgs; [
    #    citrix_workspace
    microsoft-edge
    master.citrix-workspace
    jfrog-cli
    (pkgs.azure-cli.withExtensions (with azure-cli-extensions; [ azure-devops ]))
  ];

}
