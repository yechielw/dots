{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    custom.terminal = lib.mkOption {
      type = lib.types.enum [
        "kitty"
        "ghostty"
      ];
      default = "ghostty";
    };
  };
  config = {
    programs.ghostty = {
      enable = config.custom.terminal == "ghostty";
      enableZshIntegration = true;
      settings = {
        window-decoration = false;
        theme = "Dark+";
        font-size = 12;
        cursor-invert-fg-bg = true;
        shell-integration-features = "ssh-terminfo,ssh-env";
        background-opacity = 0.97;
      };
    };

    programs.kitty = {
      enable = config.custom.terminal == "kitty";
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
}
