return {
  'coder/claudecode.nvim',
  event = 'VeryLazy',
  opts = {
    auto_start = true,
    track_selection = true,
    terminal = {
      provider = 'none',
    },
    diff = {
      layout = 'vertical',
    },
  },
  keys = {
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection to Claude' },
    { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add buffer to Claude' },
    { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept Claude diff' },
    { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny Claude diff' },
    { '<leader>cr', '<cmd>ClaudeCodeStart<cr>', desc = 'Restart Claude bridge server' },
    {
      '<leader>c?',
      function()
        local dir = vim.fn.expand '~/.claude/ide'
        local locks = vim.fn.glob(dir .. '/*.lock', false, true)
        if #locks == 0 then
          vim.notify('No Claude IDE bridge running. Try <leader>cr.', vim.log.levels.WARN)
          return
        end
        local lines = {}
        for _, path in ipairs(locks) do
          local ok, data = pcall(vim.fn.readfile, path)
          local port = vim.fn.fnamemodify(path, ':t:r')
          if ok then
            local parsed_ok, parsed = pcall(vim.json.decode, table.concat(data, '\n'))
            if parsed_ok then
              local ws = parsed.workspaceFolders and table.concat(parsed.workspaceFolders, ', ') or '?'
              local ide = parsed.ideName or '?'
              local pid = parsed.pid or '?'
              table.insert(lines, ('port=%s  ide=%s  pid=%s  ws=%s'):format(port, ide, pid, ws))
            else
              table.insert(lines, ('port=%s  (unparseable lock)'):format(port))
            end
          end
        end
        vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'Claude IDE bridge' })
      end,
      desc = 'Show Claude bridge status',
    },
  },
}
