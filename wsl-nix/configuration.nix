{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    inputs.home-manager.nixosModules.default
  ];

  wsl.enable = true;
  wsl.defaultUser = "yechiel";
  wsl.wslConf.network.hostname = "wsl-nix";
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    netexec
    wget
    neovim
    git
    netexec
    gzip
    unzip
    gcc
    curl
    nodejs
    go
    pipx
    bloodhound-py
    eza  
    bat
    zsh
    ripgrep
    zoxide
    fzf
    pyenv
    atuin
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

