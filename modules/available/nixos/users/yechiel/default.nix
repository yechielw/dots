{ ... }:
{
  users.users.yechiel = {
    isNormalUser = true;
    description = "Yechiel Worenklein";
    home = "/home/yechiel";
    extraGroups =
      [ "wheel" "networkmanager" "i2c" "wireshark" "docker" "libvirtd" "kvm" ];
  };
}
