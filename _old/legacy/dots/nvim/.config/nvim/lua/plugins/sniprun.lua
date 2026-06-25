return {
  "michaelb/sniprun",
  event = "VeryLazy",
  branch = "master",
  build = "sh install.sh",
  keys = {
    {"<leader>fv", function() require'sniprun'.run('v') end,  mode = { "v" }, desc = "SnipRun"},
    {"<leader>ff", function() require'sniprun'.run('n') end,  mode = { "n" }, desc = "SnipRun"},
  },
  opts = {
--    display = "NvimNotify"
  },
}
