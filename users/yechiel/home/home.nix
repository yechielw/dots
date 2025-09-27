{
  settings,
  inputs,
  ...
}:
{
  users.users.yechiel = {
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
      "docker"
    ];
  };

  imports = [
    inputs.home-manager.nixosModules.default
    ./yechiel.nix
  ];

}
