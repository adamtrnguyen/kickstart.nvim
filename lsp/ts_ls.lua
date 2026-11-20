-- JavaScript and TypeScript (typescript-language-server, with the TypeScript 6 that
-- Mason installs beside it). JavaScript is not type-checked unless the repo's
-- jsconfig.json or tsconfig.json turns `checkJs` on.
return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { { 'tsconfig.json', 'jsconfig.json' }, 'package.json', '.git' },
  init_options = { hostInfo = 'neovim' },
}
