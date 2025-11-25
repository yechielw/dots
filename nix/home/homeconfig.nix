{ pkgs, pkgs-master, ... }:
{

  hm.appearance.enable = true;
  hm.tui.enable = true;
  hm.hypr.enable = true;
  wm.enable = true;
  programs = {

    # vicinae = {
    #   settings = {
    #     popToRootOnClose = true;
    #     window.rounding = 7;
    #
    #   };
    # };

    ghostty = {
      enable = true;
      enableZshIntegration = true;
      # package = inputs.ghostty.packages.${pkgs.system}.default;
      settings = {
        window-decoration = false;
        theme = "Dark+";
        font-size = 12;
        cursor-invert-fg-bg = true;
        shell-integration-features = "ssh-terminfo,ssh-env";
      };
    };

    #starship.enable = true;

    # walker = {
    #   enable = true;
    #   runAsService = true;
    # };

    home-manager.enable = true;

    git = {

      enable = true;
      settings = {
        user = {
          name = "Yechiel Worenklein";
          email = "41305372+yechielw@users.noreply.github.com";
        };

        init.defaultBranch = "master";
        pull.rebase = false;
      };
      signing = {
        format = "ssh";
        key = "/home/yechiel/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
      # extraConfig = {
      # };
    };

    difftastic = {
      enable = true;
      git.enable = true;
    };

    kitty = {
      enable = true;
      package = pkgs-master.kitty;
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
      themeFile = "GitHub_Dark";
      settings = {
        enable_audio_bell = false;
        hide_window_decorations = true;
        allow_remote_control = "yes";

      };
    };

  };

  home = {
    username = "yechiel";
    homeDirectory = "/home/yechiel";

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
      "${pkgs.rquickshare}/share/applications/rquickshare.desktop"
      "${pkgs.bitwarden-desktop}/share/applications/bitwarden.desktop"
      "${pkgs.beeper}/share/applications/beepertexts.desktop"
    ];
  };
  xdg.configFile = { };
  nixGL.vulkan.enable = true;
}
