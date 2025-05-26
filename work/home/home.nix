{
  pkgs,
  inputs,
  settings,
  ...
}:
let
  background = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish-dark-gray.png";
    sha256 = "07zl1dlxqh9dav9pibnhr2x1llywwnyphmzcdqaby7dz5js184ly";
  };
in
{
  imports = [
    ./zsh.nix
    ./custom.nix
    ./wm.nix
    inputs.walker.homeManagerModules.default
    #inputs.cosmic-manager.homeManagerModules.cosmic-manager
    #    ./cosmic.nix

  ];

  wm.enable = true;
  programs = {
    oh-my-posh-dev = {
      enable = true;
      enableZshIntegration = true;
      configFile = ../../ohmyposh/config.toml;
    };

    home-manager.enable = true;
    command-not-found.enable = false;
    nix-index.enable = true;

    git = {
      enable = true;
      userName = "Yechiel Worenklein";
      userEmail = "41305372+yechielw@users.noreply.github.com";
      difftastic.enable = true;
      difftastic.background = "dark";
      extraConfig.init.defaultBranch = "master";
    };

    zoxide = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [
        "--disable-up-arrow"
      ];
    };
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        #name = "MonacoLigaturized";
        size = 12;
      };
      shellIntegration = {
        enableZshIntegration = true;
        mode = "enabled";
      };
      themeFile = "rose-pine-moon";
      settings = {
        enable_audio_bell = false;
        hide_window_decorations = true;
      };
    };

    lesspipe.enable = true;

    pyenv = {
      enable = false;
      enableZshIntegration = true;
    };
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

  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };

    font = {
      name = "SFProText Nerd Font";
      size = 11;
    };

    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "gtk2";
  };

  home = {
    username = "${settings.username}";
    homeDirectory = "/home/${settings.username}";

    stateVersion = "24.05";

    packages = [ ];

    pointerCursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      x11.enable = true;
    };

    file = {
    };

    sessionPath = [
      "$HOME/.pyenv/bin"
      "$HOME/.local/bin"
      "$HOME/go/bin"
      "$HOME/.cargo/bin"
    ];

    sessionVariables = {
      EDITOR = "nvim";
      NIX_AUTO_RUN = 1;
      NIXPKGS_ALLOW_UNFREE = 1;
    };

    shellAliases = {
      diff = "diff --color=auto";
      ip = "ip --color=auto";
      ls = "eza";
      ll = "eza -la -g --icons";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      cat = "bat -p";
      history = "history 0";
    };
  };

  xdg.configFile = {
    nvim.source = ./nixcats;
    zellij.source = ../../zellij/.config/zellij;
    alacritty.source = ../../alacritty/.config/alacritty;
    "hypr/hyprland.conf".source = ../../hypr/hyprland.conf;
    "hypr/scripts".source = ../../hypr/scripts;
    waybar.source = ../../waybar;
    oh-my-posh.source = ../../ohmyposh;
    ghostty.source = ../../ghostty/.config/ghostty;
  };
}
