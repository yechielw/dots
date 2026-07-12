{writeTextDir,vicinae, hostPlatform, ...}:

writeTextDir "etc/chromium/native-messaging-hosts/com.vicinae.vicinae.json" (
          builtins.toJSON {
            name = "com.vicinae.vicinae";
            description = "Vicinae Native Messaging Host";
            path = "${vicinae.packages.${hostPlatform.system}.default}/libexec/vicinae/vicinae-browser-link";
            type = "stdio";
            allowed_origins = [ "chrome-extension://kcmipingpfbohfjckomimmahknoddnke/" ];
          }
        )
