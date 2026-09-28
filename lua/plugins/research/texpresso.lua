return {
  'let-def/texpresso.vim',
  ft = { 'tex' },
  config = function()
    vim.env.PATH = '/opt/homebrew/bin:/usr/local/bin:' .. vim.env.PATH

    local texpresso = require 'texpresso'
    local launch = texpresso.launch
    texpresso.launch = function(args)
      args = vim.deepcopy(#args > 0 and args or texpresso.last_args)
      if #args == 0 then
        return launch(args)
      end
      -- The TeX Live provider can select doc/ examples instead of real packages.
      if not vim.tbl_contains(args, '-tectonic') and not vim.tbl_contains(args, '-texlive') then
        table.insert(args, 1, '-tectonic')
      end

      -- Wait for old on_exit callbacks before launch sets the new job ID.
      -- Inspect channels because the plugin's running flag can already be stale.
      local jobs = {}
      for _, channel in ipairs(vim.api.nvim_list_chans()) do
        if channel.argv and vim.fs.basename(channel.argv[1]) == 'texpresso' then
          vim.fn.jobstop(channel.id)
          table.insert(jobs, channel.id)
        end
      end
      for _, status in ipairs(vim.fn.jobwait(jobs, 2000)) do
        if status == -1 then
          vim.notify('TeXpresso is still stopping; try again shortly.', vim.log.levels.WARN)
          return
        end
      end

      launch(args)
      -- Include unsaved text immediately instead of waiting for the next edit.
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == 'tex' then
          texpresso.reload(buf)
        end
      end
    end

    vim.keymap.set('n', '<leader>tp', function()
      local file = vim.api.nvim_buf_get_name(0)
      local root = vim.fs.root(file, { '.latexmkrc', 'latexmkrc', '.git' }) or vim.fs.dirname(file)
      texpresso.launch { '-I', root, file }
    end, { desc = 'TeXpresso preview' })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TeXpressoWorkingDirectory', { clear = true }),
      pattern = 'tex',
      callback = function()
        vim.cmd 'silent! lcd %:p:h'
      end,
    })
  end,
}
