{ config,lib, pkgs,inputs, ... }:

{

  imports = [ 
    #./hyprlnad.nix 
    inputs.ags.homeManagerModules.default

  ];
  services.swaync.enable = true;
  services.avizo.enable = true; 
  services.kdeconnect.enable = true;


  services.copyq.enable = true;
  #  services.blueman-applet.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = let 
      nineish = pkgs.fetchurl { 
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish-dark-gray.png";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
    in {
      ipc = "on";
      #splash = false;
      #splash_offset = 2.0;

      preload =
        [ "/tmp/nine.png" ];

      wallpaper = [
        ", /tmp/nine.png"
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
          timeout = 120;
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


  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
  programs.home-manager.enable = true;
  programs.zsh.enable = true;
  programs.nix-index.enable = true;

  gtk = {
    enable = true;
    theme.name = "WhiteSur-Dark";
    theme.package = pkgs.whitesur-gtk-theme;

    font.name = "DejaVu Sans";
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

  # stylix.enable = true;
  



  home = {
    username = "yechiel";
    homeDirectory = "/home/yechiel";
     
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
     };
     
    sessionVariables = {
      EDITOR = "nvim";
      };
  };
}
