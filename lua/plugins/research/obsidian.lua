-- lua/plugins/obsidian.lua
local vault = '/Users/adam/Library/CloudStorage/OneDrive-Personal/Obsidian Vault'

return {
  -- Migrated from epwalsh/obsidian.nvim 2026-09-13: upstream's last push was
  -- 2026-06-04 while this community fork is pushed to daily. Not archived,
  -- just no longer where the work happens.
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  ft = 'markdown',
  -- Not every machine has the vault. obsidian.nvim refuses to set up without
  -- a workspace ("At least one workspace is required!"), so where the folder
  -- is absent the plugin is not loaded. `cond`, not `enabled`: lazy.nvim keeps
  -- it installed.
  cond = function()
    return vim.uv.fs_stat(vault) ~= nil
  end,
  -- No dependencies: plenary is no longer needed, and completion is provided by
  -- the plugin's built-in obsidian-ls LSP server, which replaced the deprecated
  -- `completion.nvim_cmp` option.
  opts = {
    workspaces = {
      {
        name = 'notes',
        path = vault,
      },
    },
    ui = { enable = true },
  },
  config = function(_, opts)
    require('obsidian').setup(opts)

    -- Default conceal for Markdown
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = 'nc'
      end,
    })

    -- Toggle keymap: <leader>uc
    vim.keymap.set('n', '<leader>uc', function()
      if vim.wo.conceallevel == 0 then
        vim.wo.conceallevel = 2
        vim.wo.concealcursor = 'nc'
        print 'Conceal enabled'
      else
        vim.wo.conceallevel = 0
        print 'Conceal disabled'
      end
    end, { desc = 'Toggle Obsidian conceal' })
  end,
}
