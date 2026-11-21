-- YAML (yaml-language-server). A file names its own schema in a first-line
-- `# yaml-language-server: $schema=<path or URL>` comment; well-known files get theirs
-- from schemastore.org.
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' },
  root_markers = { '.git' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    -- Validation and completion only. Its formatter would otherwise run on every save
    -- (conform falls back to the server's) and re-wrap hand-written YAML.
    yaml = { format = { enable = false } },
  },
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
