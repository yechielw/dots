{ ... }:
{
  programs = {
    cosmic-ext-tweaks.enable = true;

  };
  wayland.desktopManager.cosmic = {
    enable = true;
    appearance = {
      theme = {
        mode = "dark";
      };
      toolkit = {
        apply_theme_global = false;
        #header_size = "Standerd";
        interface_density = "Standerd";
        interface_font = {
          family = "SFProText Nerd Font";
        };
        monospace_font.family = "JetBrainsMono Nerd Font Mono";

        show_maximize = false;
        show_minimize = false;

      };

      applets = {
        app-list = {
          settings = { };
        };
        audio.settings.show_media_controls_in_top_panel = true;
      };
    };
  };
}
