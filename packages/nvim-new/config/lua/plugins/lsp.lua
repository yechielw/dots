require('fidget').setup {}
require('lazydev').setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.keymap.set('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { buffer = event.buf, desc = '[T]oggle Inlay [H]ints' })
    end
  end,
})

local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('lua_ls', {
  settings = {
    capabilities = capabilities,
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        disable = { 'missing-fields' },
      },
      hint = { enable = true },
    },
  },
})

vim.lsp.config('omnisharp', {
  handlers = {
    ['textDocument/definition'] = require('omnisharp_extended').definition_handler,
    ['textDocument/typeDefinition'] = require('omnisharp_extended').type_definition_handler,
    ['textDocument/references'] = require('omnisharp_extended').references_handler,
    ['textDocument/implementation'] = require('omnisharp_extended').implementation_handler,
  },
  keys = {
    {
      'gd',
      function()
        require('omnisharp_extended').telescope_lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
  },
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
})

vim.lsp.enable { 'lua_ls', 'nixd', 'omnisharp', 'basedpyright', 'terraformls' }
