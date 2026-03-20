-- Script runner using snacks.nvim terminal (stays inside neovim, toggleable)
return {
  'folke/snacks.nvim',
  optional = true,
  keys = {
    {
      '<leader>rr',
      function()
        local file = vim.fn.expand '%:p'
        if file == '' then
          vim.notify('No file to run', vim.log.levels.WARN)
          return
        end
        Snacks.terminal.toggle('uv run python ' .. vim.fn.shellescape(file), {
          win = { position = 'bottom', height = 0.3 },
        })
      end,
      desc = '[R]un file with uv',
    },
    {
      '<leader>rc',
      function()
        local file = vim.fn.expand '%:p'
        vim.ui.input({ prompt = 'uv run: ', default = 'python ' .. file }, function(cmd)
          if cmd then
            Snacks.terminal('uv run ' .. cmd, {
              win = { position = 'bottom', height = 0.3 },
            })
          end
        end)
      end,
      desc = '[R]un [c]ustom uv command',
    },
    {
      '<leader>rt',
      function()
        Snacks.terminal(nil, {
          win = { position = 'bottom', height = 0.3 },
        })
      end,
      desc = '[R]un [t]erminal (toggle)',
    },
  },
}
