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

      # antidote = {
      #   enable = true;
      #   plugins = [
      #     #"zsh-users/zsh-history-substring-search"
      #     "zdharma-continuum/fast-syntax-highlighting"
      #     #"zsh-users/zsh-autosuggestions"
      #     "zsh-users/zsh-completions"
      #     #"olivierverdier/zsh-git-prompt"
      #   ];
      # };
      initContent = ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        #fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
        #fpath+=(${pkgs.nix-zsh-completions}/share/zsh/site-functions)
        #source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh
        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
        [ ! -e $TMUX ] || tmux a
      '';
    };
  };

}
