{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    onlyoffice-desktopeditors
    hello
    helix
    master.hello-unfree
    chatgpt
    codex
    playwright-mcp
    stable.mcp-nixos
    yechiel.ocr
    amp-cli
    terraform
    terraform-lsp
    yechiel.nvim
    inputs.omniflake.flakes.raise.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    inputs.omniflake.flakes.zen-browser-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
    adwaita-icon-theme
    antigravity-cli
    master.bitwarden-desktop
    alsa-utils
    beeper
    element-desktop
    xxd
    wirelesstools
    bluez-tools
    nixfmt
    dig
    curl
    gcc
    file
    git
    go
    (google-chrome.override {
      commandLineArgs = "--disable-features=WaylandWpColorManagerV1 --password-store=basic";
    })
    gzip
    nodejs
    #pipx
    pyenv
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
    (sbctl.override {
      databasePath = "/var/lib/sbctl";
    })
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
    python3Packages.impacket
    (python3.withPackages (
      ps: with ps; [
        pip
        debugpy
      ]
    ))
    # imported from .nix-profile
    pandoc
    stable.semgrep
    xq
    inetutils
    sqlite
    gnumake
    ffuf
    openssl
    nix-init
    yt-dlp
    exiftool
    master.bitwarden-cli
    subfinder
    wpscan
    comma
    master.vial
    btop
    libreoffice
    dash
    gh
    awscli2
    avalonia-ilspy
    zip
    dnschef
    zathura
    tree
    # grayjay
    wike
  ];
}
