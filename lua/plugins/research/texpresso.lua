return {
  'let-def/texpresso.vim',
  ft = { 'tex' },
  config = function()
    -- Make sure nvim can find the binaries (macOS GUI/PATH gotcha)
    vim.env.PATH = '/opt/homebrew/bin:/usr/local/bin:' .. vim.env.PATH

    -- If `texpresso` isn't in PATH, hardcode it instead:
    -- vim.g.texpresso_bin = vim.fn.expand("~/Research/livetex/texpresso/build/texpresso")

    -- Optional: open TeXpresso for the root file you choose
    vim.keymap.set('n', '<leader>tp', function()
      -- TeXpresso searches beside the document; include the project root
      -- so reviews/ can use a shared .sty file in its parent directory.
      local file = vim.api.nvim_buf_get_name(0)
      local root = vim.fs.root(file, { '.latexmkrc', 'latexmkrc', '.git' }) or vim.fs.dirname(file)
      require('texpresso').launch { '-I', root, file }
    end, { desc = 'TeXpresso preview' })

    -- Most common cause of black window: wrong working directory.
    -- This makes TeXpresso run from the current file's folder.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'tex',
      callback = function()
        vim.cmd 'silent! lcd %:p:h'
      end,
    })
  end,
}
