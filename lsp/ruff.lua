return {
  -- The repo's own ruff when its virtualenv pins one, so lint results match its gate.
  cmd = require('repo_venv').lsp_cmd('ruff', { 'server' }),
  filetypes = { 'python' },
  root_markers = { 'ruff.toml', 'pyproject.toml', '.git' },
  init_options = {
    settings = {
      lineLength = 100,
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
}
