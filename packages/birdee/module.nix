{
  wlib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];

  settings.config_directory = ./.;

  specs.kickstart = {
    lazy = false;
    data = with pkgs.vimPlugins; [
      # Plugins enabled by Kickstart's init.lua.
      guess-indent-nvim
      gitsigns-nvim
      which-key-nvim
      tokyonight-nvim
      todo-comments-nvim
      mini-nvim
      plenary-nvim
      telescope-nvim
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      fidget-nvim
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      mason-tool-installer-nvim
      conform-nvim
      luasnip
      blink-cmp
      nvim-treesitter.withAllGrammars

      # Plugins used by the optional lua/kickstart/plugins examples.
      nvim-autopairs
      nvim-dap
      nvim-dap-ui
      nvim-nio
      mason-nvim-dap-nvim
      nvim-dap-go
      indent-blankline-nvim
      nvim-lint
      neo-tree-nvim
      nui-nvim
    ];
  };

  runtimePkgs = with pkgs; [
    fd
    git
    gnumake
    lua-language-server
    ripgrep
    stylua
    tree-sitter
    unzip
  ];
}
