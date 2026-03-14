return {
  cmd = { 'ruff', 'server' },
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
