programs.zsh = {
  enable = true;
  history = {
    size = 50000;
    ignoreAllDups = true;
  };
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  shellAliases = {
    diff = "diff --color=auto";
    ip = "ip --color=auto";
    ll = "eza -la -g --icons";
    vi = "nvim";
    vim = "nvim";
    cat = "bat -p";
    history = "history 0";
    hosts = "sudo.exe wsl nvim /mnt/c/Windows/System32/drivers/etc/hosts";
  };
  autosuggestion.strategy = [
    "history"
    "completion"
  ]
};
