{
  pkgs,
  inputs,
  pkgs-master,
  self,
  ...
}:
# let
#   nixCatsOutputs = import ../config/nixcats/default.nix inputs;
# in
{
  # nixpkgs.overlays = [
  #   nixCatsOutputs.overlays.default
  # ];
  environment.systemPackages = with pkgs; [
    amp-cli
    terraform
    terraform-lsp
    self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    # nvim
    inputs.raise.defaultPackage.x86_64-linux
    # inputs.cats.packages.${pkgs.stdenv.hostPlatform.system}.default
    #nixCatsOutputs.packages.${pkgs.stdenv.hostPlatform.system}.default
    #    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    adwaita-icon-theme
    gemini-cli
    # inputs.nixpkgs-master.legacyPackages.${pkgs.stdenv.hostPlatform.system}.bitwarden-desktop
    bitwarden-desktop
    alsa-utils
    beeper
    element-desktop
    xxd
    wirelesstools
    bluez-tools
    nixfmt
    dig
    (flameshot.override {
      enableWlrSupport = true;
      enableMonochromeIcon = true;
    })
    curl
    gcc
    file
    git
    go
    (google-chrome.override { commandLineArgs = "--disable-features=WaylandWpColorManagerV1 --password-store=basic"; })
    gzip
    nodejs
    pipx
    pyenv
    thunderbird
    unzip
    wget
    freerdp
    killall
    cargo
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    podman-desktop
    docker-compose
    podman-compose
    distrobox
    pciutils
    libmbim
    #    rquickshare
    sbctl
    trayscale
    usbutils
    cachix
    jq
    jqp
    p7zip
    uv
    # zed-editor
    ddcutil
    ddccontrol
    nettools
    python312Packages.impacket
    (python3.withPackages (
      ps: with ps; [
        pip
        debugpy
      ]
    ))
  ];
}
