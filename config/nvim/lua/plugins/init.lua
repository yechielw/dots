-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    "norcalli/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    opts = { ["*"] = { RRGGBBAA = true, rgb_fn = true, hsl_fn = true, css = true, css_fn = true, } },
  },
  {
    "mbbill/undotree",
    keys = {
      {"<leader>u", vim.cmd.UndotreeToggle, desc = "Undotree Toggle"},
    },
  },
}

