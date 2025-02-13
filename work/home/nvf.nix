{
  pkgs,
  inputs,
  settings,
  ...
}:
{

  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;
    settings = {

      vim = {

        options = {
          shiftwidth = 2;
          tabstop = 2;

        };

        enableLuaLoader = true; # the experimental Lua module loader to speed up the start up process

        lsp = {
          enable = true;
          formatOnSave = true;
          null-ls.enable = true;
        };
        languages = {
          nix = {
            enable = true;
            format.type = "nixfmt";
          };

          python.enable = true;
          lua.enable = true;
          html.enable = true;
          ts.enable = true;
          bash.enable = true;
          csharp.enable = true;
          java.enable = true;
          kotlin.enable = true;
          php.enable = true;

          markdown.enable = true;
          markdown.extensions.render-markdown-nvim.enable = true;

          enableDAP = true;
          enableFormat = true;
          enableLSP = true;
          enableTreesitter = true;

        };

        assistant.copilot = {
          enable = true;
          cmp.enable = true;
          # mappings.panel.accept = "";
        };

        autocomplete.nvim-cmp = {
          enable = true;
          mappings = {
            confirm = "<C-y>";
            next = "<C-n>";
            previous = "<C-p>";
          };
        };
        binds = {
          whichKey.enable = true;
        };

        comments.comment-nvim.enable = true;

        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };
        git.enable = true;

        snippets.luasnip.enable = true;

        statusline.lualine = {
          enable = true;
        };

        #tabline.nvimBufferline.enable = true;
        telescope.enable = true;

        undoFile.enable = true;

        theme = {
          enable = true;
          name = "rose-pine";
          style = "main";
          transparent = true;
        };
      };

    };
  };
}
