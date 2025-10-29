return { -- Autocompletion
  'saghen/blink.cmp',
  event = 'VimEnter',
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      name = 'luasnip',
      build = require('nixCatsUtils').lazyAdd((function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)()),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      opts = {},
    },
    'folke/lazydev.nvim',
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      preset = 'default',

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'copilot', 'buffer' },
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 100,
          async = true,
        },
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },
  -- 'hrsh7th/nvim-cmp',
  -- event = 'InsertEnter',
  -- dependencies = {
  --   -- Snippet Engine & its associated nvim-cmp source
  -- {
  --   'L3MON4D3/LuaSnip',
  --   --  nixCats: nix downloads it with a different file name.
  --   -- tell lazy about that.
  --   name = 'luasnip',
  --   build = require('nixCatsUtils').lazyAdd((function()
  --     -- Build Step is needed for regex support in snippets.
  --     -- This step is not supported in many windows environments.
  --     -- Remove the below condition to re-enable on windows.
  --     if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --       return
  --     end
  --     return 'make install_jsregexp'
  --   end)()),
  --   dependencies = {
  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  -- {
  --   'rafamadriz/friendly-snippets',
  --   config = function()
  --     require('luasnip.loaders.from_vscode').lazy_load()
  --   end,
  -- },
  -- },
  -- },
  --   'saadparwaiz1/cmp_luasnip',
  --
  --   -- Adds other completion capabilities.
  --   --  nvim-cmp does not ship with all sources by default. They are split
  --   --  into multiple repos for maintenance purposes.
  --   'hrsh7th/cmp-nvim-lsp',
  --   'hrsh7th/cmp-path',
  -- },
  -- config = function()
  --   -- See `:help cmp`
  --   local cmp = require 'cmp'
  --   local luasnip = require 'luasnip'
  --   luasnip.config.setup {}
  --
  --   cmp.setup {
  --     snippet = {
  --       expand = function(args)
  --         luasnip.lsp_expand(args.body)
  --       end,
  --     },
  --     completion = { completeopt = 'menu,menuone,noinsert' },
  --
  --     -- For an understanding of why these mappings were
  --     -- chosen, you will need to read `:help ins-completion`
  --     --
  --     -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --     mapping = cmp.mapping.preset.insert {
  --       -- Select the [n]ext item
  --       ['<C-n>'] = cmp.mapping.select_next_item(),
  --       -- Select the [p]revious item
  --       ['<C-p>'] = cmp.mapping.select_prev_item(),
  --
  --       -- Scroll the documentation window [b]ack / [f]orward
  --       ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --       ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --
  --       -- Accept ([y]es) the completion.
  --       --  This will auto-import if your LSP supports it.
  --       --  This will expand snippets if the LSP sent a snippet.
  --       ['<C-y>'] = cmp.mapping.confirm { select = true },
  --
  --       -- If you prefer more traditional completion keymaps,
  --       -- you can uncomment the following lines
  --       --['<CR>'] = cmp.mapping.confirm { select = true },
  --       --['<Tab>'] = cmp.mapping.select_next_item(),
  --       --['<S-Tab>'] = cmp.mapping.select_prev_item(),
  --
  --       -- Manually trigger a completion from nvim-cmp.
  --       --  Generally you don't need this, because nvim-cmp will display
  --       --  completions whenever it has completion options available.
  --       ['<C-Space>'] = cmp.mapping.complete {},
  --
  --       -- Think of <c-l> as moving to the right of your snippet expansion.
  --       --  So if you have a snippet that's like:
  --       --  function $name($args)
  --       --    $body
  --       --  end
  --       --
  --       -- <c-l> will move you to the right of each of the expansion locations.
  --       -- <c-h> is similar, except moving you backwards.
  --       ['<C-l>'] = cmp.mapping(function()
  --         if luasnip.expand_or_locally_jumpable() then
  --           luasnip.expand_or_jump()
  --         end
  --       end, { 'i', 's' }),
  --       ['<C-h>'] = cmp.mapping(function()
  --         if luasnip.locally_jumpable(-1) then
  --           luasnip.jump(-1)
  --         end
  --       end, { 'i', 's' }),
  --
  --       -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --       --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --     },
  --     sources = {
  --       { name = 'copilot' },
  --       { name = 'nvim_lsp' },
  --       { name = 'luasnip' },
  --       { name = 'path' },
  --     },
  --   }
  -- end,
}
