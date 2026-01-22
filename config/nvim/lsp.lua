local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end
  end,
  root_markers = { '.git' },
})
require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('expert', {
  root_markers = { 'mix.exs', '.git' },
  settings = {
    workspaceSymbols = {
      minQueryLength = 0
    }
  }
})
vim.lsp.enable 'expert'

vim.lsp.enable 'tailwindcss'
vim.lsp.enable 'jsonls'
vim.lsp.enable 'yamlls'
vim.lsp.enable 'ts_ls'
vim.lsp.enable 'bashls'
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'vimls'

vim.diagnostic.handlers.loclist = {
  show = function(_, _, _, opts)
    -- Generally don't want it to open on every update
    opts.loclist.open = opts.loclist.open or false
    local winid = vim.api.nvim_get_current_win()
    vim.diagnostic.setloclist(opts.loclist)
    vim.api.nvim_set_current_win(winid)
  end
}
