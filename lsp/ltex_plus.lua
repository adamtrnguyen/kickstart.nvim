return {
  cmd = { 'ltex-ls-plus' },
  filetypes = { 'tex', 'plaintex', 'bib', 'markdown', 'text' },
  settings = {
    ltex = {
      language = 'en-US',
      -- Disable spell checking (use Neovim's built-in spell for that)
      -- Focus on grammar and style
      checkFrequency = 'save',
      diagnosticSeverity = 'hint',
      additionalRules = {
        enablePickyRules = true,
        motherTongue = 'en-US',
      },
      disabledRules = {
        ['en-US'] = {
          'MORFOLOGIK_RULE_EN_US', -- spell checking (handled by Neovim spell)
          'WHITESPACE_RULE',       -- whitespace formatting
        },
      },
      latex = {
        commands = {
          -- Add custom LaTeX commands ltex should ignore
          ['\\cite{}'] = 'dummy',
          ['\\citet{}'] = 'dummy',
          ['\\citep{}'] = 'dummy',
          ['\\ref{}'] = 'dummy',
          ['\\eqref{}'] = 'dummy',
          ['\\label{}'] = 'dummy',
          ['\\autoref{}'] = 'dummy',
          ['\\Cref{}'] = 'dummy',
          ['\\cref{}'] = 'dummy',
        },
      },
    },
  },
}
