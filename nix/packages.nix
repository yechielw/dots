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
    self.packages.${pkgs.system}.nvim
    # nvim
    inputs.raise.defaultPackage.x86_64-linux
    # inputs.cats.packages.${pkgs.system}.default
    #nixCatsOutputs.packages.${pkgs.system}.default
    #    inputs.ghostty.packages.${pkgs.system}.default
    inputs.zen-browser.packages.${pkgs.system}.default
    adwaita-icon-theme
    gemini-cli
    inputs.nixpkgs-master.legacyPackages.${pkgs.system}.bitwarden-desktop
    alsa-utils
    pkgs-master.beeper
    element-desktop
    xxd
    wirelesstools
    bluez-tools
    nixfmt-rfc-style
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
    google-chrome
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
    rquickshare
    sbctl
    trayscale
    usbutils
    cachix
    jq
    jqp
    p7zip
    uv
    zed-editor
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
