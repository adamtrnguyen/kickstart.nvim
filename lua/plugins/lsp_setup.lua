return {
  'mason-org/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    require('mason').setup()

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- grn (rename), gra (code action), grr (references), grD (declaration)
        -- are Neovim 0.11 defaults — no need to map them

        -- Override with snacks.picker for richer UI
        map('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
        map('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
        map('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
        map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
        map('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')

        -- Document highlight on CursorHold
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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

        -- Toggle inlay hints
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Disable inlay hints in insert mode (they fire on every keystroke)
    vim.api.nvim_create_autocmd('InsertEnter', {
      callback = function() vim.lsp.inlay_hint.enable(false) end,
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
      callback = function() vim.lsp.inlay_hint.enable(true) end,
    })

    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      },
      virtual_text = { source = 'if_many', spacing = 2 },
    }

    -- Set global capabilities from blink.cmp for all LSP servers
    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
    })

    -- Enable native LSP servers (configured in lsp/*.lua)
    vim.lsp.enable({ 'basedpyright', 'ruff', 'lua_ls' })

    -- Ensure tools are installed via Mason
    require('mason-tool-installer').setup {
      ensure_installed = {
        'basedpyright',
        'ruff',
        'lua-language-server',
        'stylua',
      },
    }
  end,
}
