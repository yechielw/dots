{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  sassc,
  glib,
  libxml2,
  gtk3,
  getent,
  which,
}:
stdenvNoCC.mkDerivation {
  pname = "mactahoe-gtk-theme";
  version = "0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-gtk-theme";
    rev = "59fc8131e293bcf0c7a8eb55ba773cbcbcccb378";
    hash = "sha256-xS/RAPAREzteA6BRL3ZGrKk8Uml6/AjZRGQGQCOCrek=";
  };

  nativeBuildInputs = [sassc glib libxml2 gtk3 getent which];

  dontBuild = true;
  dontFixup = true;

  postPatch = ''
    # The build sandbox has no real user in /etc/passwd; bypass getent lookup.
    substituteInPlace libs/lib-core.sh \
      --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' \
                     'MY_HOME="$HOME"' \
      --replace-fail 'SUDO_BIN="$(which sudo)"' \
                     'SUDO_BIN=""' \
      --replace-fail 'if [[ ! -w "/root" ]]; then' \
                     'if false; then'
    patchShebangs install.sh libs/lib-install.sh libs/lib-core.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    HOME=$TMPDIR ./install.sh -l \
      --dest $out/share/themes \
      --silent-mode

    runHook postInstall
  '';

  meta = with lib; {
    description = "MacOS Tahoe-like theme for GTK based desktops";
    homepage = "https://github.com/vinceliuice/MacTahoe-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
  };
}
