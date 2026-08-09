{
  nix.settings = {
    trusted-users = [ "@wheel" ];
    substituters = [
      "https://yechielw.cachix.org/"
      "https://vicinae.cachix.org"
      "https://hyprland.cachix.org"
      # "ssh://eu.nixbuild.net"
    ];
    trusted-public-keys = [
      "yechielw.cachix.org-1:QTDOxv1zSo70kFYjmifZlZ5329v9QjX7sfpJqwv8h8c="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      # ZIB0CP-1:ApkQd3BTT++gJj9vh8e58TDvpZOXdc76S4vkFP1zqhA="
    ];
  };
}
