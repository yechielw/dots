{ ... }:
{
  programs = {
    ssh = {
      extraConfig = ''
        Host eu.nixbuild.net
        PubkeyAcceptedKeyTypes ssh-ed25519
        ServerAliveInterval 60
        IdentityFile /path/to/your/private/key
      '';
      knownHosts = {
        nixbuild = {
          hostNames = [ "eu.nixbuild.net" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
        };
      };
    };
    # zoom-us.package = pkgs.master.zoom-us;
    nh = {
      enable = true;
      clean.enable = true;
      flake = "/home/yechiel/dots";
    };
    zsh.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    kdeconnect.enable = true;
    java.enable = true;
  };
}
