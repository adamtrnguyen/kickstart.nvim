-- The repo's own ruff when its virtualenv pins one, otherwise Mason's: a different
-- ruff version can sort imports and format differently from the repo's gate.
local function repo_ruff(_, ctx)
  return require('repo_venv').find(ctx.dirname, 'ruff') or 'ruff'
end

return { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        cpp = { 'clang-format' },
        c = { 'clang-format' },
        python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      },
      formatters = {
        ruff_fix = { command = repo_ruff },
        ruff_organize_imports = { command = repo_ruff },
        ruff_format = { command = repo_ruff },
      },
    },
}

