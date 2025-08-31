vim.lsp.config('elixirls', {
  cmd = { vim.fn.expand("~/.elixir-ls/language_server.sh") };
})
vim.lsp.enable('elixirls')

vim.lsp.enable('ruby_lsp')
