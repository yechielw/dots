{pkgs,pkgs-master,inputs,custom-packages, ...}:

{
  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs; [
    
    (custom-packages.burpsuite.override { proEdition = true; })
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
  ];

  #environment.etc."usr/share/seclists".source = "${pkgs.seclists}/share/wordlists/seclists";
}
