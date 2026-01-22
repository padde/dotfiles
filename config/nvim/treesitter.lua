vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'elixir', 'eelixir', 'heex'},
  callback = function(ev) vim.treesitter.start() end,
})

-- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.wo[0][0].foldmethod = 'expr'

-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
