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
      userName = "Yechiel Worenklein";
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
      "${pkgs-master.rquickshare}/share/applications/rquickshare.desktop"
      "${pkgs-master.bitwarden}/share/applications/bitwarden.desktop"
      "${pkgs-master.beeper}/share/applications/beepertexts.desktop"
    ];
  };
  xdg.configFile = { };
  nixGL.vulkan.enable = true;
}
