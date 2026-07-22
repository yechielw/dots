{ pkgs
, ...
}: {
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
}
