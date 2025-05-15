{
  ...
}:
{
  services.desktopManager.cosmic = {
    enable = true;
    xwayland = true;

  };
  # nix.settings = {
  #
  #   substituters = [
  #     "https://cosmic.cachix.org/"
  #   ];
  #   trusted-public-keys = [
  #     "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
  #   ];
  # };
}
