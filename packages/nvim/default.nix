{
  inputs,
  pkgs,
  localSystem ? pkgs.stdenv.hostPlatform.system,
  ...
}:
(
  inputs.nixCats.utils.baseBuilder "${inputs.self + /config/nvim}"
  {
    system = localSystem;
    inherit (inputs) nixpkgs;

    dependencyOverlays = [
      (inputs.nixCats.utils.standardPluginOverlay inputs)
    ];

    extra_pkg_config = {
      allowUnfree = true;
    };
  }
  ({pkgs, ...}: {
    lspsAndRuntimeDeps.general = with pkgs; [
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
      csharp-ls
      nodejs
      omnisharp-roslyn
      roslyn
      delve
      markdownlint-cli
    ];

    startupPlugins.general = with pkgs.vimPlugins; [
      nvim-colorizer-lua
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
      omnisharp-extended-lsp-nvim
      roslyn-nvim
      dressing-nvim
      img-clip-nvim
      avante-nvim
      nvim-dap
      nvim-dap-ui
      nvim-dap-go
      nvim-nio
      indent-blankline-nvim
      nvim-lint
      nvim-autopairs
      neo-tree-nvim
      nui-nvim
    ];
  })
  {
    nvim = _: {
      settings.wrapRc = true;
      categories.general = true;
    };
  }
)
"nvim"
