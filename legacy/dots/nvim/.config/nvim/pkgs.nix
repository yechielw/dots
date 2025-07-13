  environment.systemPackages = with pkgs; [
        neovim
        git
        wget
        gzip
        unzip
        gcc
        curl
        nodejs
        go
        (python311.withPackages(ps: with ps; [
                pynvim
                pip
                debugpy
        ]))
  ];
