{
  config,
  pkgs,
  settings,
  inputs,
  impurity,
  pkgs-master,
  ...
}:
{
  users.users.yechiel = {
    isNormalUser = true;
    description = "${settings.description}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
      "i2c"
      "wireshark"
      "adbusers"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bckup";
    extraSpecialArgs = {
      inherit inputs;
      inherit settings;
      inherit impurity;
    };
    users = {
      yechiel = {
        imports = [
          ./zsh.nix
          #./oh-my-posh.nix
          ./wm.nix
          inputs.walker.homeManagerModules.default
          #inputs.cosmic-manager.homeManagerModules.cosmic-manager
          #    ./cosmic.nix
          ./custom.nix
        ];

        wm.enable = true;
        programs = {

          ghostty = {
            enable = true;
            enableZshIntegration = true;
            package = inputs.ghostty.packages.${pkgs.system}.default;
            settings = {
              window-decoration = false;
              theme = "Dark+";
              font-size = 12;
              cursor-invert-fg-bg = true;
            };
          };

          starship.enable = true;
          oh-my-posh-dev = {
            enable = false;
            enableZshIntegration = true;
            configFile = ../../../config/ohmyposh/config.toml;
          };
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

          walker = {
            enable = true;
            runAsService = true;
          };

          home-manager.enable = true;
          command-not-found.enable = false;
          nix-index.enable = true;

          git = {
            enable = true;
            userName = "${settings.description}";
            userEmail = "41305372+yechielw@users.noreply.github.com";
            difftastic.enable = true;
            difftastic.background = "dark";
            signing = {
              format = "ssh";
              key = "/home/yechiel/.ssh/id_ed25519.pub";
              signByDefault = true;
            };
            extraConfig = {
              init.defaultBranch = "master";
              pull.rebase = false;
            };
          };

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

          iconTheme = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
            # name = "WhiteSur";
            # package = pkgs.whitesur-icon-theme;
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
            "$HO../../../confign"
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
            #ls = "eza";
            #ll = "eza -la -g --icons";
            v = "nvim";
            vi = "nvim";
            vim = "nvim";
            cat = "bat -p";
            history = "history 0";
          };
        };

        xdg.autostart =
          let
            e = pkgs.lib.getExe;
          in
          {
            enable = true;
            entries = [
              # "${pkgs-master.bitwarden}/bin/rquickshare"
              # "${pkgs-master.bitwarden}/bin/trayscale"
              # "${pkgs-master.beeper}/bin/beeper"
              (e pkgs-master.bitwarden)
              (e pkgs-master.trayscale)
              (e pkgs-master.beeper)
              (e pkgs-master.element-desktop)
            ];
          };
        xdg.configFile =
          let
            link = impurity.link;
          in
          {
            nvim.source = link ../../../config/work/home/nixcats;
            zellij.source = link ../../../config/zellij/.config/zellij;
            alacritty.source = link ../../../config/alacritty/.config/alacritty;
            "hypr/hyprland.conf".source = link ../../../config/hypr/hyprland.conf;
            "hypr/scripts".source = link ../../../config/hypr/scripts;
            waybar.source = link ../../../config/waybar;
            #oh-my-posh.source = link ../../../config/ohmyposh;
            #ghostty.source = link ../../../config/ghostty/.config/ghostty;
          };
        nixGL.vulkan.enable = true;
      };
    };
  };
}
