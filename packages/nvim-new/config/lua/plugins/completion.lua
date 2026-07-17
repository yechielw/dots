require('luasnip.loaders.from_vscode').lazy_load()

local luasnip = require 'luasnip'
vim.keymap.set('i', '<C-K>', function()
  luasnip.expand()
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-L>', function()
  luasnip.jump(1)
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-J>', function()
  luasnip.jump(-1)
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-E>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })

require('copilot').setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}

require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    menu = {
      draw = {
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          { 'source_name' },
        },
      },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev', 'copilot', 'buffer' },
    per_filetype = {},
    providers = {
      buffer = {
        min_keyword_length = 3,
        max_items = 5,
      },
      copilot = {
        name = 'Copilot',
        module = 'blink-cmp-copilot',
        score_offset = -10,
        max_items = 3,
        async = true,
      },
      lazydev = {
        module = 'lazydev.integrations.blink',
        score_offset = 90,
      },
    },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
