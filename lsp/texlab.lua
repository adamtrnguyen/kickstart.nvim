return {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  settings = {
    texlab = {
      build = {
        executable = 'latexmk',
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '-outdir=build', '%f' },
        onSave = false, -- vimtex handles continuous builds
        forwardSearchAfter = false,
      },
      forwardSearch = {
        executable = '/Applications/Skim.app/Contents/SharedSupport/displayline',
        args = { '-g', '%l', '%p', '%f' },
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = false,
      },
      diagnostics = {
        ignoredPatterns = { 'Overfull', 'Underfull' },
      },
    },
  },
}
