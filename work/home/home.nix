{ pkgs,inputs, custom-packges, settings, ... }:

let 
  background = pkgs.fetchurl { 
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish-dark-gray.png";
    sha256 = "07zl1dlxqh9dav9pibnhr2x1llywwnyphmzcdqaby7dz5js184ly";
  };
in
{

  imports = [ 
    #./hyprlnad.nix 

  ];
  
    #systemd.user.settings.Manager.DefaultEnvironment = {
    #WAYLAND_DISPLAY = "wayland-1";
  #};

  services.swaync.enable = true;
  #services.avizo.enable = true; 
  services.swayosd.enable = true;
  services.swayosd.topMargin = 0.75;

  services.kdeconnect.enable = true;


  services.copyq.enable = true;
  #services.blueman-applet.enable = true;
  
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      #splash = false;
      #splash_offset = 2.0;

      preload =
        [ "${background}" ];

      wallpaper = [
        ", ${background}"
      ];
    };
  };
  
  services.hypridle = {
    
    enable = true;

    settings = {
      general = {
        #before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.hyprlock = {

    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };


      background = [
        {
          path = "${background}" ;
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };

  
  programs.home-manager.enable = true;
  programs.zsh.enable = true;
  programs.nix-index.enable = true;

  gtk = {
    enable = true;
    theme.name = "WhiteSur-Dark";
    theme.package = pkgs.whitesur-gtk-theme;
    #theme.package = whitesurWithL;

    #font.name = "DejaVu Sans";
    font.name = "SFProText Nerd Font";
    font.size = 11;

    cursorTheme.name = "BreezeX-RosePine-Linux";
    cursorTheme.package = pkgs.rose-pine-cursor;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  qt.enable = true;
  qt.platformTheme.name = "gtk";
  qt.style.name = "gtk2";




  home = {
    username = "${settings.username}";
    homeDirectory = "/home/${settings.username}";
     
    stateVersion = "24.05"; 
     
    packages = [   ];
    file = {
       ".config/nvim".source      = ../../nvim/.config/nvim;
       ".config/zsh".source       = ../../zsh/.config/zsh;
       ".zshrc".source		  = ../../zsh/.zshrc;
       ".gitconfig".source	  = ../../git/.gitconfig;
       ".config/tmux".source      = ../../tmux/.config/tmux;
       ".config/zellij".source    = ../../zellij/.config/zellij;
       ".config/alacritty".source = ../../alacritty/.config/alacritty;
       ".config/kitty".source     = ../../kitty;
       ".config/hypr/hyprland.conf".source     = ../../hypr/hyprland.conf;
       ".config/hypr/scripts".source           = ../../hypr/scripts;
       ".config/waybar".source                 = ../../waybar;
     };
     
    sessionVariables = {
      EDITOR = "nvim";
      };
  };
}
