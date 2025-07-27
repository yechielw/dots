{
  pkgs,
  inputs,
  pkgs-master,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.raise.defaultPackage.x86_64-linux
    inputs.cats.packages.${pkgs.system}.default
    #    inputs.ghostty.packages.${pkgs.system}.default
    inputs.zen-browser.packages.${pkgs.system}.default
    gemini-cli
    clamav
    pkgs-master.bitwarden
    nixd
    alsa-utils
    beeper
    element-desktop
    obsidian
    xxd
    wirelesstools
    qmk
    via
    bluez-tools
    blueberry
    espanso-wayland
    nixfmt-rfc-style
    dig
    libmbim
    copyq
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
    kitty
    #neovim
    lua-language-server
    nodejs
    pipx
    pyenv
    thunderbird
    unzip
    wget
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
    element-desktop
    jq
    jqp
    p7zip
    uv
    zed-editor
    ddcutil
    ddccontrol
    python312Packages.impacket
    (python3.withPackages (
      ps: with ps; [
        pynvim
        pip
        debugpy
      ]
    ))
  ];
}
