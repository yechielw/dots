{ pkgs, cats, ... }:

{
  environment.systemPackages = with pkgs; [
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
}
