{
  inputs,
  ...
}:
{
  imports = [
    (inputs.import-tree ../../modules/home)
  ];

  hm.tui.enable = true;
  home.stateVersion = "25.05";
  home.username = "test";
  home.homeDirectory = "/tmp/home";
}
