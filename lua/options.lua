vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true
-- vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

vim.cmd "highlight Normal     ctermbg=NONE guibg=NONE"
vim.cmd "highlight LineNr     ctermbg=NONE guibg=NONE"
vim.cmd "highlight SignColumn ctermbg=NONE guibg=NONE"
vim.cmd "highlight BufferLineFill ctermbg=NONE guibg=NONE"
vim.cmd "highlight NotifyBackground ctermbg=NONE guibg=NONE"

vim.fn.sign_define('DapBreakpoint', {
  text = '',
  texthl = 'DapBreakpoint',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint'
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


