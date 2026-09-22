{
  cacert,
  citrix-workspace,
  curl,
  htmlq,
  stdenvNoCC,
}:

let
  inherit (citrix-workspace) version;

  src = stdenvNoCC.mkDerivation {
    name = "linuxx64-${version}.tar.gz";

    nativeBuildInputs = [
      curl
      htmlq
    ];

    dontUnpack = true;

    buildCommand = ''
      downloadUrl="$(${curl}/bin/curl \
        --cacert ${cacert}/etc/ssl/certs/ca-bundle.crt \
        --fail \
        --location \
        --silent \
        --show-error \
        https://www.citrix.com/downloads/workspace-app/betas-and-tech-previews/workspace-app-tp-for-linux.html \
        | ${htmlq}/bin/htmlq -a rel 'a.ctx-dl-link[rel*="/linuxx64-"]')"

      case "$downloadUrl" in
        //downloads.citrix.com/*/linuxx64-${version}.tar.gz\?*) ;;
        *)
          echo "Unexpected Citrix download URL: $downloadUrl" >&2
          exit 1
          ;;
      esac

      ${curl}/bin/curl \
        --cacert ${cacert}/etc/ssl/certs/ca-bundle.crt \
        --fail \
        --location \
        --retry 3 \
        --show-error \
        "https:$downloadUrl" \
        --output "$out"
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "flat";
    outputHash = "sha256-B5L4vjMgBVRHiD+Q6i0pK5RSXyQgGoSxWeIvFB61wJ0=";
  };
in
citrix-workspace.overrideAttrs (_: {
  inherit src;
})
