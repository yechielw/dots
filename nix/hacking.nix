{
  pkgs,
  inputs,
  master,
  stable,
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
  vm = pkgs.androidenv.emulateApp {
    name = "empt";
    platformVersion = "35";
    abiVersion = "x86_64"; # armeabi-v7a, mips, x86_64
    systemImageType = "google_apis_playstore";
    configOptions = {
      "hw.gpu.enabled" = "yes";
    };

    androidEmulatorFlags = "-no-snapshot-load -no-snapshot-save -accel on -gpu swiftshader_indirect -qemu -enable-kvm";

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
    vm
    freeda
    clogcat
    trufflehog
    #buprp.pro
    jython
    python312Packages.bloodhound-py
    metasploit
    caido
    #netexec
    stable.netexec
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
