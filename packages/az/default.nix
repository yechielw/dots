{ pkgs, ... }:
# pkgs.azure-cli.extensions.azure-devops.overrideAttrs (old: {
#   propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ pkgs.python3Packages.keyring ];
# })
# pkgs.azure-cli.withExtensions (with pkgs.azure-cli-extensions; [ azure-devops ])
let
  az-unwrapped = pkgs.azure-cli.withExtensions [ pkgs.azure-cli.extensions.azure-devops ];
in
pkgs.symlinkJoin {
  name = "azure-cli-wrapped";
  paths = [ az-unwrapped ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  postBuild = ''
          rm "$out/bin/az"
          cat > "$out/bin/az" <<'WRAPPER'
    #!/usr/bin/env bash
    # Use Nix-managed bicep (pkgs.bicep) instead of az's self-downloaded one;
    # avoids libicu crash because the nixpkgs build is properly patchelf'd.
    export AZURE_BICEP_USE_BINARY_FROM_PATH=true
    case "$1" in
        devops|repos|pipelines)
            # Persistent, isolated config dir — see "Config dir layout" header note.
            az_devops_cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/az-devops"
            mkdir -p "$az_devops_cfg"
            AZURE_DEVOPS_EXT_PAT=$(secret-tool lookup service azure-devops type cli) \
            AZURE_CONFIG_DIR="$az_devops_cfg" \
                exec ${az-unwrapped}/bin/az "$@" ;;
        rest)
            shift
            # Inject PAT only for ADO URLs; let MSAL bearer flow through for everything else
            # (Graph, ARM, etc. — they reject Basic auth with "JWT not well formed").
            is_ado=false
            for arg in "$@"; do
                case "$arg" in
                    *dev.azure.com*|*visualstudio.com*|*vsrm.dev.azure.com*)
                        is_ado=true; break ;;
                esac
            done
            if $is_ado; then
                PAT=$(secret-tool lookup service azure-devops type cli)
                AUTH=$(printf ':%s' "$PAT" | base64 -w0)
                exec ${az-unwrapped}/bin/az rest \
                    --skip-authorization-header \
                    --headers "Authorization=Basic $AUTH" \
                    "$@"
            else
                exec ${az-unwrapped}/bin/az rest "$@"
            fi
            ;;
        *)
            exec ${az-unwrapped}/bin/az "$@" ;;
    esac
    WRAPPER
          chmod +x "$out/bin/az"
  '';
}
