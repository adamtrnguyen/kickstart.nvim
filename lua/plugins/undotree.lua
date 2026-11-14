-- Undotree keymap — uses built-in :Undotree (Neovim 0.12+).
-- It ships as an optional package, so it has to be loaded before first use.
vim.keymap.set('n', '<leader>u', function()
  if vim.fn.exists ':Undotree' ~= 2 then
    vim.cmd.packadd 'nvim.undotree'
  end
  vim.cmd.Undotree()
end, { desc = 'Toggle Undotree' })
return {}
