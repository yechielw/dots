{ inputs
, pkgs
, ...
}:
inputs.bw.lib.evalPackage [
  { inherit pkgs; }
  ({ wlib
   , pkgs
   , ...
   }: {
    imports = [ wlib.wrapperModules.neovim ];

    config = {
      binName = "nvim-new";

      settings = {
        config_directory = ./config;
        dont_link = true;
      };

      # Keep the old nixCats plugin set, minus lazy.nvim. The wrapper installs
      # these as native Neovim start packages, so no Lua plugin manager is needed.
      specs.plugins = {
        autoconfig = false;
        data = with pkgs.vimPlugins; [
          nvim-colorizer-lua
          neogit
          diffview-nvim
          undotree
          vim-sleuth
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
          blink-cmp-copilot
          blink-cmp
          friendly-snippets
          luasnip
          todo-comments-nvim
          mini-nvim
          nvim-treesitter.withAllGrammars
          render-markdown-nvim
          copilot-lua
          rose-pine
          amp-nvim
          omnisharp-extended-lsp-nvim
          nvim-dap
          nvim-dap-ui
          nvim-dap-go
          nvim-nio
          indent-blankline-nvim
          nvim-lint
          neo-tree-nvim
          nui-nvim
        ];
      };

      # These were wrapped by nixCats but had no enabled lazy.nvim spec. Keep
      # them in the package closure as optional native packages without sourcing
      # their plugin files at startup.
      specs.inactive = {
        lazy = true;
        autoconfig = false;
        data = with pkgs.vimPlugins; [
          cmp_luasnip
          cmp-nvim-lsp
          cmp-path
          tokyonight-nvim
          CopilotChat-nvim
          copilot-cmp
          vim-dotenv
          promise-async
          roslyn-nvim
          dressing-nvim
          img-clip-nvim
          avante-nvim
          nvim-autopairs
        ];
      };

      runtimePkgs =
        (with pkgs; [
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
          basedpyright
          nodejs
          omnisharp-roslyn
          roslyn
          delve
          markdownlint-cli
        ])
        ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.csharp-ls ];
    };
  })
]
