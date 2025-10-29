-- Set up lspconfig.
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { '.git' },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('elixirls', {
  cmd = { vim.fn.expand("~/.elixir-ls/language_server.sh") },
  capabilities = capabilities
})
vim.lsp.enable('elixirls')

vim.lsp.config('tailwindcss', {
  init_options = {
    userLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex",
    },
  }
})
vim.lsp.enable('tailwindcss')

vim.diagnostic.handlers.loclist = {
  show = function(_, _, _, opts)
    -- Generally don't want it to open on every update
    opts.loclist.open = opts.loclist.open or false
    local winid = vim.api.nvim_get_current_win()
    vim.diagnostic.setloclist(opts.loclist)
    vim.api.nvim_set_current_win(winid)
  end
}
