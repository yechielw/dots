return {
  'nvim-telescope/telescope.nvim',
  event = "VeryLazy",
  branch = '0.1.x',
  opts = {
    pickers = {
      colorscheme = {
        enable_preview = true
      }
    }
  },
  config = function()
    
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    }
    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require("telescope").load_extension, "ui-select")
    -- See `:help telescope.builtin`
    -- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    -- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    -- vim.keymap.set('n', '<leader>/', function()
    --   -- You can pass additional configuration to telescope to change theme, layout, etc.
    --   require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --     winblend = 10,
    --     previewer = false,
    --   })
    -- end, { desc = '[/] Fuzzily search in current buffer' })
    -- 
    -- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
    -- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    -- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    -- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    -- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    -- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    -- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
  end,
  keys = {

    {'<leader>?', function() require('telescope.builtin').oldfiles() end, desc = '[?] Find recently opened files' },
    {'<leader><space>', function() require('telescope.builtin').buffers() end, desc = '[ ] Find existing buffers' },
    {'<leader>/', function()
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
    end,  desc = '[/] Fuzzily search in current buffer' },
    {'<leader>gf', function() require('telescope.builtin').git_files() end, desc = 'Search [G]it [F]iles'},
    {'<leader>sf', function() require('telescope.builtin').find_files() end, desc = '[S]earch [F]iles'},
    {'<leader>sh', function() require('telescope.builtin').help_tags() end, desc = '[S]earch [H]elp'},
    {'<leader>sw', function() require('telescope.builtin').grep_string() end, desc = '[S]earch current [W]ord'},
    {'<leader>sg', function() require('telescope.builtin').live_grep() end, desc = '[S]earch by [G]rep'},
    {'<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics'},
    {'<leader>sr', function() require('telescope.builtin').resume() end, desc = '[S]earch [R]esume'},
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
}
