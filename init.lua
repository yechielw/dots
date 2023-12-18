vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.lazy')
require('lazy').setup("plugins")
require('options')
require('keymaps')
require('config.telescope')
require('config.treesitter')
require('config.lsp')
require('config.cmp')

