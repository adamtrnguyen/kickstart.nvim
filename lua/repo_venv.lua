-- Tools a repo pins in its own virtualenv (`.venv/bin/<tool>`, where uv puts them).
-- The Python language servers and formatters prefer these to Mason's copies, so the
-- editor checks and formats with the same versions as the repo's own gate.
local M = {}

---The nearest `.venv/bin/<name>` at or above `dir`.
---@param dir string? directory to search upward from
---@param name string executable name, e.g. 'ruff'
---@return string? path absolute path, nil when no virtualenv above `dir` has it
function M.find(dir, name)
  if not dir or dir == '' then
    return nil
  end
  for _, venv in ipairs(vim.fs.find('.venv', { upward = true, path = dir, limit = math.huge })) do
    local path = vim.fs.joinpath(venv, 'bin', name)
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

---The same, for the file in a buffer (the working directory for an unnamed buffer).
---@param bufnr integer
---@param name string
---@return string?
function M.find_for_buf(bufnr, name)
  local file = vim.api.nvim_buf_get_name(bufnr)
  local dir = file ~= '' and vim.fs.dirname(file) or vim.fn.getcwd()
  return M.find(dir, name)
end

---A `cmd` for an `lsp/<server>.lua`: the repo's own copy of the server when its
---virtualenv has one, otherwise `name` from PATH (Mason's).
---@param name string
---@param args string[]
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers, config: vim.lsp.ClientConfig): vim.lsp.rpc.PublicClient
function M.lsp_cmd(name, args)
  return function(dispatchers, config)
    local cmd = { M.find(config.root_dir, name) or name }
    vim.list_extend(cmd, args)
    return vim.lsp.rpc.start(cmd, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end
end

return M
