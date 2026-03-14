-- Snacks.nvim — consolidated plugin replacing telescope, neoscroll,
-- indent-blankline, and lazygit.nvim
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    -- Search (replaces telescope)
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
    { '<leader>sf', function() Snacks.picker.files() end, desc = '[S]earch [F]iles' },
    { '<leader>ss', function() Snacks.picker.pickers() end, desc = '[S]earch [S]elect Picker' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
    { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent Files' },
    { '<leader><leader>', function() Snacks.picker.buffers() end, desc = '[ ] Find existing buffers' },
    { '<leader>/', function() Snacks.picker.lines() end, desc = '[/] Fuzzily search in current buffer' },
    { '<leader>s/', function() Snacks.picker.grep_buffers() end, desc = '[S]earch [/] in Open Files' },
    { '<leader>sn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = '[S]earch [N]eovim files' },
    -- Lazygit
    { '<leader>lg', function() Snacks.lazygit() end, desc = 'LazyGit' },
    -- Zen mode
    { '<leader>z', function() Snacks.zen() end, desc = '[Z]en mode' },
  },
  opts = {
    bigfile = { enabled = true },
    -- Smooth scrolling (replaces neoscroll)
    scroll = {},
    -- Indent guides (replaces indent-blankline)
    indent = {},
    -- Picker (replaces telescope)
    picker = {
      sources = {
        files = {
          exclude = { 'node_modules', '.git', '__pycache__', '*.pyc', '*.egg-info', '.venv' },
        },
        grep = {
          exclude = { 'node_modules', '.git', '__pycache__', '*.pyc', '*.egg-info', '.venv' },
        },
      },
    },
    -- Lazygit (replaces lazygit.nvim)
    lazygit = {},
    -- Notifications
    notifier = {},
    -- Auto-highlight LSP references
    words = {},
    -- Better vim.ui.input
    input = {},
    -- Zen mode
    zen = {},
    -- Terminal (existing config)
    styles = {
      terminal = {
        keys = {
          nav_h = { '<c-h>', function() vim.cmd('TmuxNavigateLeft') end, mode = 't', desc = 'Navigate left' },
          nav_j = { '<c-j>', function() vim.cmd('TmuxNavigateDown') end, mode = 't', desc = 'Navigate down' },
          nav_k = { '<c-k>', function() vim.cmd('TmuxNavigateUp') end, mode = 't', desc = 'Navigate up' },
          nav_l = { '<c-l>', function() vim.cmd('TmuxNavigateRight') end, mode = 't', desc = 'Navigate right' },
        },
      },
    },
  },
}
