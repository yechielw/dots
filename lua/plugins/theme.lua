return {
    "catppuccin/nvim",
    name = "catppuccin-mocha",
    opts = {
      integrations = {
        cmp = true,
        treesitter = true,
        mason = true,
        noice = true,
        dap = true,
        dat_ui = true,
        which_key = false,
      },
    },
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  }
