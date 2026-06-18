# SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

# Citrix Secure Access client (package `nsgclient`) for Linux - the NetScaler
# Gateway VPN client. Unlike `citrix-workspace`, upstream ships a plain Debian
# package with a fixed file tree, so this derivation is just:
#
#   unpack .deb  ->  autoPatchelfHook  ->  wrap for GTK
#
# The `NSGClient` binary hardcodes absolute `/opt/Citrix/...` paths for its
# resources, config files and the IPC socket-path file, so it only *runs*
# correctly when the companion NixOS module has materialised that tree.
# Building the package alone is not enough.
{
  lib,
  stdenv,
  fetchurl,
  requireFile,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  makeWrapper,

  # Runtime libraries - the union of the `DT_NEEDED` entries of NSGClient,
  # service/nsgverctl and EPA/libepalib.so (see `patchelf --print-needed`).
  curl,
  dconf,
  glib,
  glib-networking,
  gpgme,
  gsettings-desktop-schemas,
  gtk3,
  libarchive,
  libayatana-appindicator,
  libnl,
  libnotify,
  libproxy,
  libuuid,
  libx11,
  # libxml2 2.14 bumped its soname to libxml2.so.16; NSGClient is linked
  # against the old libxml2.so.2, so we need the pinned 2.13 series.
  libxml2_13,
  libxscrnsaver,
  networkmanager,
  openssl,
  procps,
  pugixml,
  webkitgtk_4_1,
}:

let
  # NSGClient and nsgverctl are linked against `libgpgme.so.11` (gpgme 1.x).
  # nixpkgs has moved to gpgme 2.x, which bumped the soname to `.so.45` and
  # left no pinned 1.x attribute behind. Override back to the last 1.x release.
  gpgme1 = gpgme.overrideAttrs (_old: rec {
    version = "1.24.3";
    src = fetchurl {
      url = "mirror://gnupg/gpgme/gpgme-${version}.tar.bz2";
      sha256 = "1pahikkdrv6d1b22ssh0vwrhy23ps9b8k4fxkxjchy5is5dpzhdz";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "citrix-secure-access";
  version = "25.8.2";

  # Unfree, EULA-gated: the .deb cannot be fetched inside the build sandbox.
  # `requireFile` makes the build fail with the message below until the file
  # has been added to the store manually.
  src = requireFile {
    name = "nsginstaller64.deb";
    sha256 = "1cq95i3i3bd67aknwxz4bdkqfj288dp0fvsa80w7g166jma0klsn";
    message = ''
      Citrix Secure Access is distributed under the Citrix EULA and cannot be
      downloaded automatically. Obtain the "Citrix Secure Access client for
      Ubuntu" .deb (named `nsginstaller64.deb`) from:

        https://www.citrix.com/downloads/citrix-gateway/

      then add it to the Nix store with:

        nix-prefetch-url file://$PWD/nsginstaller64.deb
    '';
  };

  # stdenv has no built-in unpacker for `.deb`; a Debian package is an `ar`
  # archive whose `data.tar.*` member holds the file tree. `dpkg-deb -x`
  # extracts exactly that tree.
  unpackCmd = "dpkg-deb -x $curSrc source";
  sourceRoot = "source";

  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
    dconf
    glib
    glib-networking
    gpgme1
    gsettings-desktop-schemas
    gtk3
    libarchive
    libayatana-appindicator
    libnl
    libnotify
    libproxy
    libuuid
    (lib.getLib libxml2_13) # libxml2's default output is `bin` (no .so)
    (lib.getLib networkmanager) # provides libnm.so.0
    openssl
    # nixpkgs builds pugixml as a static archive by default; the client needs
    # the shared libpugixml.so.1.
    (pugixml.override { shared = true; })
    stdenv.cc.cc # libstdc++ / libgcc_s
    webkitgtk_4_1
    libx11
    libxscrnsaver # libXss.so.1
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications
    cp -r opt $out/opt

    mkdir -p $out/libexec/citrix-secure-access/dpkg-compat
    cat >$out/libexec/citrix-secure-access/dpkg-compat/dpkg <<'EOF'
    #!/bin/sh
    case "$*" in
      "-l" | "-l "* | "--list" | "--list "*)
        if command -v microsoft-edge-stable >/dev/null 2>&1; then
          printf 'ii  microsoft-edge-stable  1  amd64  Microsoft Edge\n'
        fi
        exec @dpkg@/bin/dpkg "$@"
        ;;
      *)
        exec @dpkg@/bin/dpkg "$@"
        ;;
    esac
    EOF
    cat >$out/libexec/citrix-secure-access/dpkg-compat/dpkg-query <<'EOF'
    #!/bin/sh
    case "$*" in
      *nsepa*)
        printf 'ii  nsepa  1  amd64  Citrix Endpoint Analysis compatibility package\n'
        exit 0
        ;;
      *)
        exec @dpkg@/bin/dpkg-query "$@"
        ;;
    esac
    EOF
    substituteInPlace $out/libexec/citrix-secure-access/dpkg-compat/dpkg \
      --replace-fail @dpkg@ ${dpkg}
    substituteInPlace $out/libexec/citrix-secure-access/dpkg-compat/dpkg-query \
      --replace-fail @dpkg@ ${dpkg}
    chmod +x $out/libexec/citrix-secure-access/dpkg-compat/dpkg \
      $out/libexec/citrix-secure-access/dpkg-compat/dpkg-query

    # `$out/bin/NSGClient` is a convenience entry point. The NixOS module
    # re-wraps it through `security.wrappers` to grant CAP_NET_RAW; the cap
    # propagates through this wrapper via ambient capabilities.
    makeWrapper $out/opt/Citrix/NSGClient/bin/NSGClient $out/bin/NSGClient \
      --prefix PATH : "$out/libexec/citrix-secure-access/dpkg-compat:${
        lib.makeBinPath [
          dpkg
          procps
        ]
      }" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
    wrapGApp $out/bin/NSGClient

    # Desktop entry: strip the hardcoded /opt path so it launches `NSGClient`
    # from PATH (which, on a NixOS host with the module, resolves to the
    # capability wrapper in /run/wrappers/bin first).
    install -Dm644 opt/Citrix/NSGClient/bin/nsgclient.desktop \
      $out/share/applications/citrix-secure-access.desktop
    substituteInPlace $out/share/applications/citrix-secure-access.desktop \
      --replace-fail "/opt/Citrix/NSGClient/bin/NSGClient" "NSGClient" \
      --replace-fail \
        "Icon=/opt/Citrix/NSGClient/resx/images/icon_vpn.ico" \
        "Icon=$out/opt/Citrix/NSGClient/resx/images/icon_vpn.ico"

    runHook postInstall
  '';

  meta = {
    description = "Citrix Secure Access client (NetScaler Gateway VPN) for Linux";
    homepage = "https://www.citrix.com/downloads/citrix-gateway/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "NSGClient";
  };
})
