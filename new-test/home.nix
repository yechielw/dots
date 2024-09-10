{ config, pkgs, ... }:

{
  home = {
    username = "yechiel";
    homeDirectory = "/home/yechiel";
    stateVersion = "24.05"; 
    packages = with pkgs;[];
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
  };
}
