{
  ...
}:
{
  users.users.yechiel = {
    isNormalUser = true;
    description = "Yechiel Worenklein";
    home = "/home/yechiel";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
      "i2c"
      "wireshark"
      "adbusers"
      "docker"
    ];
  };
}
