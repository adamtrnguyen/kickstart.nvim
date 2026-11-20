local repo_venv = require 'repo_venv'

-- Python type checking in a repo that pins ty in its virtualenv. That repo's gate
-- is ty, so the editor runs the same binary; basedpyright stays off there
-- (lsp/basedpyright.lua). Every other Python buffer gets basedpyright.
return {
  cmd = repo_venv.lsp_cmd('ty', { 'server' }),
  filetypes = { 'python' },
  root_dir = function(bufnr, on_dir)
    if repo_venv.find_for_buf(bufnr, 'ty') then
      on_dir(vim.fs.root(bufnr, { 'ty.toml', 'pyproject.toml', '.git' }))
    end
  end,
}
