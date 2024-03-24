return {
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '┊',
      }
    },
  },
  {
    'norcalli/nvim-colorizer.lua', -- #ee55aa
    config = function()
      require('colorizer').setup()
    end,
  },

}
