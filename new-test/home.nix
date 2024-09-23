{ config, pkgs, inputs, ... }:

{
  home = {
    username = "yechiel";
    homeDirectory = "/home/yechiel";
    stateVersion = "24.05"; 
    packages = with pkgs;[
      #gnomeExtensions.pop-shell  
    ];
    fonts.fontconfig.enable = true;
    imports = [
      inputs.ags.homeManagerModules.default
    ];
    file = {            
      ".config/nvim".source      = ../nvim/.config/nvim;
      ".config/zsh".source       = ../zsh/.config/zsh;
      ".zshrc".source		   = ../zsh/.zshrc;
      ".gitconfig".source	   = ../git/.gitconfig;
      ".config/tmux".source      = ../tmux/.config/tmux;
      ".config/zellij".source    = ../zellij/.config/zellij;
      ".config/alacritty".source = ../alacritty/.config/alacritty;
    };
   sessionVariables = {
     EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;
    zsh.enable = true;
    ags = { 
      enable = true;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };
  };
}
