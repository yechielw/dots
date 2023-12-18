return 
  {
    'codota/tabnine-nvim',
    build = "./dl_binaries.sh",
    main = 'tabnine',
    opts = {
    },
    config = function()
      require 'tabnine'.setup({
        accept_keymap = "<C-Right>",
      })
      local chat = require("tabnine.chat")
      chat.enabled = true
      require("tabnine.chat.user_commands").setup()
    end,
  }
