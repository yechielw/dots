vim.cmd.colorscheme 'rose-pine'
vim.cmd.hi 'Comment gui=none'

require('colorizer').setup {
  ['*'] = {
    RRGGBBAA = true,
    rgb_fn = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
  },
}

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Undotree Toggle' })

require('todo-comments').setup { signs = false }
require('Comment').setup {}
require('ibl').setup {}

require('mini.ai').setup {
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}
require('mini.surround').setup()
require('mini.pick').setup()

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function()
  return '%2l:%-2v'
end

require('which-key').setup()
require('which-key').add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>c_', hidden = true },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>d_', hidden = true },
  { '<leader>r', group = '[R]ename' },
  { '<leader>r_', hidden = true },
  { '<leader>s', group = '[S]earch' },
  { '<leader>s_', hidden = true },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>t_', hidden = true },
  { '<leader>w', group = '[W]orkspace' },
  { '<leader>w_', hidden = true },
  {
    mode = { 'v' },
    { '<leader>h', group = 'Git [H]unk' },
    { '<leader>h_', hidden = true },
  },
}
