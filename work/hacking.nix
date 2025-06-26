{
  pkgs,
  ...
}:

let
  clogcat = pkgs.stdenv.mkDerivation {
    name = "clogcat";
    src = ./../scripts/colorlogcat/coloredlogcat.py;
    format = "other";
    phases = [ "installPhase" ];
    installPhase = ''install -Dm755 $src $out/bin/clogcat'';

  };
  freeda = pkgs.writeShellApplication {
    name = "frid";
    text = ''
        cd ~/Documents/projects/frida-interception-and-unpinning
        adb reverse tcp:8080 tcp:8080
        frida -U \
      -l ./config.js \
      -l ./native-connect-hook.js \
      -l ./native-tls-hook.js \
      -l ./android/android-proxy-override.js \
      -l ./android/android-system-certificate-injection.js \
      -l ./android/android-certificate-unpinning.js \
      -l ./android/android-certificate-unpinning-fallback.js \
      -l ../frida_rootandsslbypass/rootandsslbypass.js -f "$1" -l frida_multiple_unpinning.js
    '';
  };
in
{
  programs.wireshark.enable = true;
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [
    freeda
    clogcat
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
