local repo_venv = require 'repo_venv'

return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  -- Not in a repo that pins ty in its virtualenv: ty is that repo's type checker
  -- (lsp/ty.lua), and two type servers would report and complete everything twice.
  root_dir = function(bufnr, on_dir)
    if not repo_venv.find_for_buf(bufnr, 'ty') then
      on_dir(vim.fs.root(bufnr, { 'pyproject.toml', 'setup.py', '.git' }))
    end
  end,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}
