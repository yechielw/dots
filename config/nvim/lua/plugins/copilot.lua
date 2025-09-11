return {
  {
    'zbirenbaum/copilot.lua',
    config = function()
      vim.g.copilot_enabled = 0
      vim.g.copilot_worspace_folders = { '~/dots' }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },
}
