{
  pkgs,
  ...
}:

let
  #buprp = pkgs.callPackage ./burpsuite/package.nix { };
in
{
  programs.wireshark.enable = true;
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [

    trufflehog
    #buprp.pro
    jython
    bloodhound-py
    caido
    netexec
    seclists
    (pkgs.wordlists.override { lists = with pkgs; [ rockyou ]; })
    feroxbuster
    nmap
    termshark
    wireshark
    metasploit
    android-studio
    apktool
    frida-tools
    android-tools
    netcat
    sqlmap
    hashcat
    jadx
    httpx
    amass
    (pkgs.androidenv.composeAndroidPackages { }).androidsdk
  ];

  #environment.etc."usr/share/seclists".source = "${pkgs.seclists}/share/wordlists/seclists";
}
