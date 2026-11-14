-- Highlight, edit, and navigate code.
--
-- This is the `main` branch of nvim-treesitter: a rewrite that only installs
-- parsers and queries. There is no `nvim-treesitter.configs` module any more;
-- highlighting and indent are switched on per buffer below. The old `master`
-- branch is frozen and does not support Neovim 0.12.
--
-- Needs the `tree-sitter` CLI (0.26.1+) and a C compiler on PATH.
-- A machine that still has the old `master` checkout needs one `:Lazy sync`
-- after pulling this; until then `config` below fails at `ts.install`.
-- Adapted from kickstart.nvim's init.lua.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- upstream: "This plugin does not support lazy-loading."
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'

    -- Async; a no-op for parsers that are already installed.
    ts.install { 'bash', 'c', 'cpp', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'python' }

    ---@param buf integer
    ---@param lang string
    local function attach(buf, lang)
      -- The buffer can be gone by the time an install finishes.
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      if not vim.treesitter.language.add(lang) then
        return
      end
      vim.treesitter.start(buf, lang)
      -- Use treesitter indent only where the language ships an indent query.
      if vim.treesitter.query.get(lang, 'indents') then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    local available = ts.get_available()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        -- LaTeX highlighting belongs to VimTeX, which uses regex syntax. init.lua
        -- runs `syntax manual`, so that has to be switched on per buffer.
        if lang == 'latex' then
          vim.bo[args.buf].syntax = 'ON'
          return
        end

        if vim.tbl_contains(ts.get_installed 'parsers', lang) then
          attach(args.buf, lang)
        elseif vim.tbl_contains(available, lang) then
          -- Install a missing parser the first time its filetype is opened.
          ts.install(lang):await(function()
            attach(args.buf, lang)
          end)
        else
          -- A parser from elsewhere (bundled with Neovim, or another plugin).
          attach(args.buf, lang)
        end
      end,
    })
  end,
}
