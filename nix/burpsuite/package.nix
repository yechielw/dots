{
  lib,
  buildFHSEnv,
  fetchurl,
  jdk,
  makeDesktopItem,
  unzip,
}:

let
  #version = "2025.1.2";

  mkBurp =
    {
      productName,
      productDesktop,
      hash,
      version,
    }:

    let
      src = fetchurl {
        name = "burpsuite.jar";
        urls = [
          "https://portswigger-cdn.net/burp/releases/download?product=${productName}&version=${version}&type=Jar"
          "https://portswigger.net/burp/releases/download?product=${productName}&version=${version}&type=Jar"
          "https://web.archive.org/web/https://portswigger.net/burp/releases/download?product=${productName}&version=${version}&type=Jar"
        ];
        sha256 = hash;
      };

      desktopItem = makeDesktopItem {
        name = "burpsuite";
        exec = "burpsuite";
        icon = "burpsuite";
        desktopName = productDesktop;
        comment = "An integrated platform for performing security testing of web applications";
        categories = [
          "Development"
          "Security"
          "System"
        ];
      };

    in
    buildFHSEnv {
      pname = "burpsuite";
      inherit version;

      runScript = "${jdk}/bin/java -jar ${src}";

      targetPkgs =
        pkgs: with pkgs; [
          alsa-lib
          at-spi2-core
          cairo
          cups
          dbus
          expat
          glib
          gtk3
          gtk3-x11
          jython
          libcanberra-gtk3
          libdrm
          udev
          libxkbcommon
          libgbm
          nspr
          nss
          pango
          xorg.libX11
          xorg.libxcb
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
        ];

      extraInstallCommands = ''
        mkdir -p "$out/share/pixmaps"
        ${lib.getBin unzip}/bin/unzip -p ${src} resources/Media/icon64${productName}.png > "$out/share/pixmaps/burpsuite.png"
        cp -r ${desktopItem}/share/applications $out/share
      '';

      meta = with lib; {
        description = "An integrated platform for performing security testing of web applications";
        longDescription = ''
          Burp Suite is an integrated platform for performing security testing of web applications.
          Its various tools work seamlessly together to support the entire testing process, from
          initial mapping and analysis of an application's attack surface, through to finding and
          exploiting security vulnerabilities.
        '';
        homepage = "https://portswigger.net/burp/";
        changelog =
          "https://portswigger.net/burp/releases/professional-community-"
          + replaceStrings [ "." ] [ "-" ] version;
        sourceProvenance = with sourceTypes; [ binaryBytecode ];
        license = licenses.unfree;
        platforms = jdk.meta.platforms;
        hydraPlatforms = [ ];
        maintainers = with maintainers; [
          bennofs
          fab
        ];
        mainProgram = "burpsuite";
      };
    };

  latestJson = builtins.fromJSON (builtins.readFile ./latest.json);

  convertEntry = entry: {
    productName = entry.ProductId;
    version = entry.Version;
    productDesktop = entry.ProductEdition;
    hash = builtins.convertHash {
      hash = entry.Sha256Checksum;
      toHashFormat = "sri";
      hashAlgo = "sha256";
    };
  };

  burpPackages = builtins.listToAttrs (
    map (entry: {
      name = entry.ProductId;
      value = mkBurp (convertEntry entry);
    }) latestJson
  );

in
burpPackages

# in
# {
#   pro = mkBurp {
#     productName = "pro";
#     productDesktop = "Burp Suite Professional Edition";
#     hash = "sha256-EIz+nMiLkrhO53MWNFgCbIT+xU3PwGH2619OtuvvYh4=";
#   };
#
#   community = mkBurp {
#     productName = "community";
#     productDesktop = "Burp Suite Community Edition";
#     hash = "sha256-Lq8ZOKOCgu7HpSO+RkAEivdWZlDcVhT7Zb1E035bk3o=";
#   };
# }
