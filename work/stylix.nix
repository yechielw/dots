{pkgs, ...}:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish-dark-gray.png";
      sha256 = "07zl1dlxqh9dav9pibnhr2x1llywwnyphmzcdqaby7dz5js184ly";
    };
    polarity = "dark";


    cursor.package = pkgs.rose-pine-cursor;
    cursor.name = "BreezeX-RoséPine";


    targets.grub.useImage = true;






  };
    
}
