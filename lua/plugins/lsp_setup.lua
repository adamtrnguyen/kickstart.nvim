return {
  'mason-org/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    -- Listed so it loads first: blink.cmp registers its completion capabilities
    -- for every server (`vim.lsp.config('*', ...)`) as it loads, and that has to
    -- happen before `vim.lsp.enable()` below.
    'saghen/blink.cmp',
  },
  config = function()
    require('mason').setup()

    -- Inlay hints: on by default, hidden while typing (they shift on every
    -- keystroke), and switched off or back on with <leader>th.
    local inlay_hints = true
    vim.lsp.inlay_hint.enable(inlay_hints)
    vim.api.nvim_create_autocmd('InsertEnter', {
      callback = function() vim.lsp.inlay_hint.enable(false) end,
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
      callback = function() vim.lsp.inlay_hint.enable(inlay_hints) end,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buf = event.buf, desc = 'LSP: ' .. desc })
        end

        -- grn (rename), gra (code action), grr (references), grD (declaration)
        -- are Neovim 0.11 defaults — no need to map them

        -- Override with snacks.picker for richer UI
        map('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
        map('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
        map('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
        map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
        map('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')

        -- Not set up here on purpose: highlighting the references under the
        -- cursor is done by snacks.words (snacks.lua), and LSP document colors
        -- are on by default since Neovim 0.12.

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            inlay_hints = not inlay_hints
            vim.lsp.inlay_hint.enable(inlay_hints)
          end, '[T]oggle Inlay [H]ints')
        end
      end,
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

    -- Enable native LSP servers (configured in lsp/*.lua)
    -- Python has two type servers and each buffer gets one: ty where the repo pins
    -- it in its virtualenv, basedpyright everywhere else (lsp/ty.lua).
    vim.lsp.enable({ 'basedpyright', 'ty', 'ruff', 'ts_ls', 'lua_ls', 'clangd', 'texlab', 'ltex_plus' })

    -- Ensure tools are installed via Mason
    require('mason-tool-installer').setup {
      ensure_installed = {
        'basedpyright',
        'ruff',
        'typescript-language-server',
        'lua-language-server',
        'stylua',
        'texlab',
        'ltex-ls-plus',
      },
    }
  end,
}
