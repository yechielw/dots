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

      oh-my-zsh = {
        enable = true;
        theme = "eastwood";
      };
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
        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
    };

    bat.enable = true;

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
    command-not-found.enable = false;
    nix-index.enable = true;

    zoxide = {
      enable = true;
      #  enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [
        #"--disable-up-arrow"
      ];
    };

    lesspipe.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      disableConfirmationPrompt = true;
      historyLimit = 50000;
      keyMode = "vi";
      customPaneNavigationAndResize = true;
      mouse = true;
      newSession = true;
      shortcut = "a";
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        ctrlw
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
        }
        {
          plugin = continuum;
          extraConfig = "set -g @continuum-restore 'on'";
        }
        {
          plugin = tmux-which-key;
          extraConfig = ''
            set -g @tmux-which-key-disable-autobuild 1
            set -g @tmux-which-key-xdg-enable 1
          '';
        }
        jump
        logging
        extrakto
      ];
      extraConfig = ''
        set -g renumber-windows on
      '';
    };

  };

  xdg.configFile = {
    zellij.source = ../../../config/zellij/.config/zellij;
  };
  home = {

    sessionVariables = {
      EDITOR = "nvim";
      NIX_AUTO_RUN = 1;
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];

    shellAliases = {
      diff = "diff --color=auto";
      ip = "ip --color=auto";
      cat = "bat";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      history = "history 0";
    };
  };
}
