{ pkgs
, inputs
, config
, lib
, ...
}:
# let
#   nixCatsOutputs = import ../config/nixcats/default.nix inputs;
# in
{
  options.profiles.packages.enable = lib.mkEnableOption "default system packages profile";

  config = lib.mkIf config.profiles.packages.enable {
    # nixpkgs.overlays = [
    #   nixCatsOutputs.overlays.default
    # ];
    environment.systemPackages = with pkgs; [
      master.hello-unfree
      yechiel.ocr
      master.noctalia-shell
      amp-cli
      terraform
      terraform-lsp
      yechiel.nvim
      # nvim
      inputs.raise.defaultPackage.${pkgs.stdenv.hostPlatform.system}
      # inputs.cats.packages.${pkgs.stdenv.hostPlatform.system}.default
      #nixCatsOutputs.packages.${pkgs.stdenv.hostPlatform.system}.default
      #    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      adwaita-icon-theme
      gemini-cli
      # bitwarden-desktop
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
      (google-chrome.override {
        commandLineArgs = "--disable-features=WaylandWpColorManagerV1 --password-store=basic";
      })
      gzip
      nodejs
      #pipx
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
      python312Packages.impacket
      (python3.withPackages (
        ps: with ps; [
          pip
          debugpy
        ]
      ))
    ];
  };
}
