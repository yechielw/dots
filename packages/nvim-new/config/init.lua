vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'options'
require 'keymaps'
require 'plugins.editor'
require 'plugins.completion'
require 'plugins.git'
require 'plugins.telescope'
require 'plugins.treesitter'
require 'plugins.tools'
require 'plugins.lsp'
