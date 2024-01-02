return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  keys = {
    {'<C-g>', function () return vim.fn['codeium#Accept']()             end, mode = 'i' },
    {'<c-;>', function() return vim.fn['codeium#CycleCompletions'](1)   end, mode = 'i' },
    {'<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1)  end, mode = 'i' },
    {'<c-x>', function() return vim.fn['codeium#Clear']()               end, mode = 'i' },
  },
  config = function ()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end
}
