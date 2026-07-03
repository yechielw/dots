{ lib
, pkgs
, config
, ...
}:
{
  options.profiles.personal.enable = lib.mkEnableOption "personal Home Manager profile";

  config = lib.mkIf config.profiles.personal.enable {
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
        # package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings = {
          window-decoration = false;
          theme = "Dark+";
          font-size = 12;
          cursor-invert-fg-bg = true;
          shell-integration-features = "ssh-terminfo,ssh-env";
          background-opacity = 0.97;
        };
      };

      #starship.enable = true;

      # walker = {
      #   enable = true;
      #   runAsService = true;
      # };

      home-manager.enable = true;


      kitty = {
        enable = true;
        # package = pkgs.master.kitty;
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

      sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = 1;
      };

    };

    xdg.configFile = { };
    # targets.genericLinux.nixGL.vulkan.enable = true;
  };
}
