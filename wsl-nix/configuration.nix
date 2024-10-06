{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    #<nixos-wsl/modules>
    inputs.nixos-wsl.nixosModules.default
    inputs.home-manager.nixosModules.default
    ./python.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "yechiel";
    wslConf.network = {
      hostname = "wsl-nix";
      generateResolvConf = false;
    };
  };
  networking.nameservers = [ "8.8.8.8" "172.24.16.1" ];
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  environment.systemPackages = with pkgs; [
    #nil # nix LSP 
    #inputs.ags-flake.packages.x86_64-linux.ags
    cargo
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
    dig
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

