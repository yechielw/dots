{
  self,
  nixpkgs,
  nixCats,
  ...
}@inputs:
let
  inherit (nixCats) utils;

  luaPath = "${self + /config/nvim}";

  # extra_pkg_config = {
  #   allowUnfree = true;
  # };

  dependencyOverlays = [
    (utils.standardPluginOverlay inputs)
  ];

  categoryDefinitions =
    {
      pkgs,
      ...
    }:
    {
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          universal-ctags
          ripgrep
          fd
          stdenv.cc.cc
          nix-doc
          lua-language-server
          nixd
          stylua
          phpactor
          gopls
          gofumpt
          pyright
          csharp-ls
          nodejs
          # amp-cli
        ];
        kickstart-debug = [ delve ];
        kickstart-lint = [ markdownlint-cli ];
      };

      startupPlugins = with pkgs.vimPlugins; {
        general = [
          neogit
          diffview-nvim
          undotree
          vim-sleuth
          lazy-nvim
          comment-nvim
          gitsigns-nvim
          which-key-nvim
          telescope-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim
          nvim-web-devicons
          plenary-nvim
          nvim-lspconfig
          lazydev-nvim
          fidget-nvim
          conform-nvim
          # nvim-cmp
          blink-cmp-copilot
          blink-cmp
          friendly-snippets
          luasnip
          cmp_luasnip
          cmp-nvim-lsp
          cmp-path
          tokyonight-nvim
          todo-comments-nvim
          mini-nvim
          nvim-treesitter.withAllGrammars
          render-markdown-nvim
          CopilotChat-nvim
          copilot-lua
          copilot-cmp
          vim-dotenv
          promise-async
          rose-pine
          amp-nvim
        ];

        avante = [
          dressing-nvim
          img-clip-nvim
          avante-nvim
        ];
        kickstart-debug = [
          nvim-dap
          nvim-dap-ui
          nvim-dap-go
          nvim-nio
        ];
        kickstart-indent_line = [ indent-blankline-nvim ];
        kickstart-lint = [ nvim-lint ];
        kickstart-autopairs = [ nvim-autopairs ];
        kickstart-neo-tree = [
          neo-tree-nvim
          nui-nvim
          nvim-web-devicons
          plenary-nvim
        ];
      };

    };

  packageDefinitions = {
    nvim =
      { pkgs, ... }:
      {
        settings = {
          wrapRc = true;
          # aliases = lib.genList (i: lib.substring 0 (i + 1) "nvim") (lib.stringLength "nvim");
        };
        categories = {
          general = true;
          avante = false;
          gitPlugins = true;
          customPlugins = true;
          test = true;
          kickstart-autopairs = true;
          kickstart-neo-tree = true;
          kickstart-debug = true;
          kickstart-lint = true;
          kickstart-indent_line = false;
          kickstart-gitsigns = true;
          have_nerd_font = true;
        };
      };
  };

  defaultPackageName = "nvim";

in
# The only thing we export: a function called by eachSystem
(
  system:
  let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit
        nixpkgs
        system
        dependencyOverlays
        # extra_pkg_config
        ;
    } categoryDefinitions packageDefinitions;

    defaultPackage = nixCatsBuilder defaultPackageName;
  in
  {
    packages = utils.mkAllWithDefault defaultPackage;
  }
)
