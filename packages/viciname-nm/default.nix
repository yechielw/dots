{
  inputs,
  pkgs,
  stdenv,
  ...
}: let
  nmh = {
    name = "com.vicinae.vicinae";
    description = "Vicinae Native Messaging Host";
    path = "${
      inputs.vicinae.packages.${stdenv.hostPlatform.system}.default
    }/libexec/vicinae/vicinae-browser-link";
    type = "stdio";
    allowed_origins = ["chrome-extension://kcmipingpfbohfjckomimmahknoddnke/"];
  };
in
  pkgs.runCommand "" {} ''
    install -Dm644 ${
      (pkgs.formats.json {}).generate "" nmh
    } $out/etc/chromium/native-messaging-hosts/com.vicinae.vicinae.json
  ''
