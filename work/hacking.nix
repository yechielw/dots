{pkgs,pkgs-master,inputs, ...}:

{
  environment.systemPackages = with pkgs; [
    
    bloodhound-py
    caido
    netexec
    seclists
    feroxbuster
    nmap
    wireshark
    metasploit
    apktool
    frida-tools
    android-tools
    netcat
    sqlmap
    hashcat
  ];
}
