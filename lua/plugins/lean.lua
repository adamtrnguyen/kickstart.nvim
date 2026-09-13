return {
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'saghen/blink.cmp',
  },
  -- Migrated 2026-09-13 from `opts = { mappings = true }`.
  --
  -- `require('lean').setup()` is deprecated and is removed in v2026.9.1
  -- (lua/lean/init.lua: vim.deprecate(..., 'vim.g.lean_config', 'v2026.9.1')).
  -- Upstream's own docstring: "Beyond configuration, calling this function (or
  -- doing anything at all besides installing lean.nvim) is no longer required,
  -- as all of its behavior activates automatically when opening Lean files."
  -- So there is no `opts`/`config` key here on purpose — lazy must not call setup().
  --
  -- Note: the top-level `mappings` boolean is NOT deprecated (default false).
  -- The deprecated one is `infoview.mappings`, a table, which we do not set.
  init = function()
    vim.g.lean_config = {
      mappings = true,
    }
  end,
}
