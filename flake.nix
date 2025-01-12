{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    custom.url = "github:yechielw/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    monaco = {
      url = "github:yechielw/monaco-nerd-font";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-howdy.url = "github:fufexan/nixpkgs/howdy";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    #ghostty.url = "github:ghostty-org/ghostty";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qti.url = "git+https://github.com/pterror/qti?submodules=1";
    qti.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.url = "github:ghostty-org/ghostty";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    nixos-cosmic,
    home-manager,
    lanzaboote,
    nix-flatpak,
    custom,
    nvf,
    ...
  } @ inputs: let
    # ...
    system = "x86_64-linux"; # change to whatever your system should be.
    settings = {
      username = "yechiel";
      hostname = "nixos";
    };

    pkgs-master = import nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };
    custom-packages = import custom {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit pkgs-master;
        inherit custom-packages;
        inherit settings;
      };
      modules = [
        {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowBroken = true;
            };
          };

          users.users.${settings.username} = {
            isNormalUser = true;
            description = "Yechiel Worenklein";
            extraGroups = ["networkmanager" "wheel" "libvirtd" "kvm" "i2c" "wireshark"];
          };

          home-manager = {
            extraSpecialArgs = {
              inherit inputs;
              inherit custom-packages;
              inherit settings;
            };
            backupFileExtension = "hm-bckup";
            users = {
              "${settings.username}" = import ./work/home/home.nix;
            };
          };
        }
        nixos-cosmic.nixosModules.default
        ./work/configuration.nix
        home-manager.nixosModules.default
        #inputs.home-manager.nixosModules.default
        #stylix.nixosModules.stylix
        lanzaboote.nixosModules.lanzaboote
        nix-flatpak.nixosModules.nix-flatpak
        nvf.nixosModules.default

        ./work/hardware-configuration.nix
        ./work/hacking.nix
        ./work/work.nix
        ./work/term.nix
        ./work/wm.nix
        ./work/vm.nix
        ./work/boot.nix
        ./work/override.nix
      ];
    };
  };
}
