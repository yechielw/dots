{
  settings,
  ...
}:
{

  users.users.${settings.username} = {
    isNormalUser = true;
    description = "${settings.description}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
      "i2c"
      "wireshark"
      "adbusers"
    ];
  };
}
