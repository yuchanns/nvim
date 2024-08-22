vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"
if vim.g.neovide then
  vim.o.guifont = "BerkeleyMono Nerd Font:h11"
end

require("core")
