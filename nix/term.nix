{ pkgs, cats, ... }:

{
  environment.systemPackages = with pkgs; [
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
