vim.api.nvim_command "set foldmethod=expr"
vim.api.nvim_command "set foldexpr=v:lua.vim.treesitter.foldexpr()"
