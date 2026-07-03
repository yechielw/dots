{ config
, lib
, ...
}:
{
  options.profiles.users.yechiel.enable = lib.mkEnableOption "Yechiel user account";

  config = lib.mkIf config.profiles.users.yechiel.enable {
    users.users.yechiel = {
      isNormalUser = true;
      description = "Yechiel Worenklein";
      home = "/home/yechiel";
      extraGroups = [ "wheel" ] 
        ++ lib.optionals config.profiles.wm.enable [ "networkmanager" "i2c" ]
        ++ lib.optionals config.profiles.hacking.enable [ "wireshark" ]
        ++ lib.optionals config.profiles.virtualisation.enable [ "docker" "libvirtd" "kvm" ];
    };
  };
}
