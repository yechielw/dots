{ config, pkgs, ... }:

{

  programs.home-manager.enable = true;
  programs.zsh.enable = true;
  
  wayland.windowManager.hyprland = {
    enable = false; 
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, F, exec, firefox"
          ", Print, exec, grimblast copy area"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
            9)
        );
    };
  
  };

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
