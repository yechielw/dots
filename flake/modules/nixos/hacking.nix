{
  pkgs,
  inputs,
  stable,
  lib,
  config,
  ...
}:

{
  options = {
    hacking.enable = lib.mkEnableOption "enable hacking tools collection";
  };

  config = lib.mkIf config.hacking.enable {
    programs.wireshark.enable = true;
    # programs.adb.enable = true;

    # imports = [
    #   inputs.burpsuite.nixosModules.default
    # ];
    environment.systemPackages = with pkgs; [
      # vm
      inputs.burpsuite.packages.${pkgs.stdenv.hostPlatform.system}.default
      android-tools
      nuclei
      trufflehog
      #buprp.pro
      jython
      python312Packages.bloodhound-py
      metasploit
      caido-cli
      netexec
      seclists
      (pkgs.wordlists.override {
        lists = with pkgs; [
          rockyou
          seclists
        ];
      })
      feroxbuster
      nmap
      termshark
      wireshark
      #android-studio
      apktool
      frida-tools
      netcat
      sqlmap
      hashcat
      jadx
      httpx
      amass
      (pkgs.androidenv.composeAndroidPackages { }).androidsdk
    ];

    #environment.etc."usr/share/seclists".source = "${pkgs.seclists}/share/wordlists/seclists";
  };
}
