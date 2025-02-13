{
  pkgs,
  pkgs-master,
  inputs,
  custom-packages,
  ...
}:

{
  programs.wireshark.enable = true;
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [

    (custom-packages.burpsuite.override { proEdition = true; })
    jython
    caido
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
