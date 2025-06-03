{
  nixpkgs,
  config,
  settings,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      android_sdk.accept_license = true;
    };
  };

  users.users.${settings.username} = {
    isNormalUser = true;
    description = "Yechiel Worenklein";
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
