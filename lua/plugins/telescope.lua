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
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-ui-select.nvim',
      config = function()
        require("telescope").load_extension("ui-select")
      end,
    },
    {
      'nvim-telescope/telescope-file-browser.nvim',
      event = "VeryLazy",
      keys = {
        { "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "File browser" },
      },
      config = function()
        require("telescope").load_extension("file_browser")
      end,
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
}
