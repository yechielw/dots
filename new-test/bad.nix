{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    (burpsuite.override { proEdition = true; })
    (nerdfonts.override { fonts = ["JetBrainsMono" "CascadiaMono"]; })
    atuin
    bat
    bloodhound-py
    caido
    citrix_workspace
    corefonts
    curl
    eza  
    fd
    fzf
    gcc
    git
    go
    google-chrome
    gzip
    kitty
    microsoft-edge
    neovim
    netexec
    nodejs
    pipx
    pyenv
    ripgrep
    thunderbird
    unetbootin
    unzip
    wget
    zoxide
    zsh
    (python311.withPackages(ps: with ps; [
       pynvim
       pip
       debugpy
       impacket
    ]))
  ];

  nixpkgs.hostPlatform = {
    system = "x86_64-linux";
  }; 
  system.stateVersion = "24.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs = {
    zsh.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "yechiel" = import ./home.nix;
    };
  };
}

