-- lua/plugins/vimtex.lua
return {
  'lervag/vimtex',
  lazy = false, -- must not lazy-load: inverse search needs :VimtexInverseSearch globally
  init = function()
    ------------------------------------------------------------------
    -- General
    ------------------------------------------------------------------
    vim.g.maplocalleader = ' ' -- so <Space>ll, <Space>lv, etc.
    vim.g.tex_flavor = 'latex'
    vim.g.vimtex_syntax_enabled = 1
    vim.opt.conceallevel = 0 -- show raw LaTeX; set 2 if you prefer pretty math

    ------------------------------------------------------------------
    -- Viewer: Skim (forward + inverse search)
    -- NOTE: In Skim > Preferences > Sync:
    --   Command:   nvim     (or full path, e.g. /opt/homebrew/bin/nvim)
    --   Arguments: --headless -c "VimtexInverseSearch %line '%file'"
    ------------------------------------------------------------------
    vim.g.vimtex_view_method = 'skim'
    vim.g.vimtex_view_skim_sync = 1
    vim.g.vimtex_view_skim_activate = 1

    ------------------------------------------------------------------
    -- Compiler: latexmk (continuous)
    ------------------------------------------------------------------
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      build_dir = 'build',
      continuous = 1,
      callback = 1,
      options = {
        '-pdf',
        '-synctex=1',
        '-interaction=nonstopmode',
        '-file-line-error',
        -- "-shell-escape", -- uncomment if you need minted/tikz externalization
      },
    }

    ------------------------------------------------------------------
    -- Quickfix / ergonomics
    ------------------------------------------------------------------
    vim.g.vimtex_quickfix_mode = 0 -- don't auto-open on warnings
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_log_ignore = { 'Underfull', 'Overfull', 'specifier changed to' }
    vim.g.vimtex_fold_enabled = 0 -- keep folds off unless you want them
  end,
}
