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
    backupFileExtension = "bck";
    extraSpecialArgs = {
      inherit inputs;
      inherit settings;
      inherit impurity;
    };
    users = {
      yechiel = {
        imports = [
          ./zsh.nix
          ./wm.nix
          inputs.walker.homeManagerModules.default
          ./hypr.nix
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

          #starship.enable = true;

          walker = {
            enable = true;
            runAsService = true;
          };

          home-manager.enable = true;

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

          kitty = {
            enable = true;
            enableGitIntegration = true;
            font = {
              name = "JetBrainsMono Nerd Font";
              package = pkgs.nerd-fonts.jetbrains-mono;
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

          sessionVariables = {
            NIXPKGS_ALLOW_UNFREE = 1;
          };

        };

        xdg.autostart = {
          enable = true;
          entries = [
            "${pkgs-master.rquickshare}/share/applications/rquickshare.desktop"
            "${pkgs-master.bitwarden}/share/applications/bitwarden.desktop"
            "${pkgs-master.beeper}/share/applications/beepertexts.desktop"
          ];
        };
        xdg.configFile = { };
        nixGL.vulkan.enable = true;
      };
    };
  };
}
