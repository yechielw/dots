{
  config,
  lib,
  pkgs,
  ...
}: {
  options.profiles.terminal.enable = lib.mkEnableOption "terminal packages profile";

  config = lib.mkIf config.profiles.terminal.enable {
    environment.systemPackages = with pkgs; [
      devenv
      witr
      atuin
      bat
      eza
      ripgrep
      zoxide
      fd
      fzf
      zellij
    ];
  };
}
