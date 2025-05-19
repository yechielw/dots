{
  pkgs,
  inputs,
  settings,
  ...
}:

{

  programs = {
    zsh = {
      enable = true;

      enableCompletion = true;

      #autosuggestion = true;

      history.append = true;
      history.expireDuplicatesFirst = true;
      history.save = 50000;
      history.size = 50000;
      history.share = true;

      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
        highlight = "fg=#999";
      };
      historySubstringSearch = {
        enable = true;
        searchDownKey = "$terminfo[kcud1]";
        searchUpKey = "$terminfo[kcuu1]";
      };

      antidote = {
        enable = true;
        plugins = [
          #"zsh-users/zsh-history-substring-search"
          "zdharma-continuum/fast-syntax-highlighting"
          #"zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-completions"
          #"olivierverdier/zsh-git-prompt"
        ];
      };
      initExtra = ''
        [ ! -e $TMUX ] || tmux a
      '';
    };
  };

}
