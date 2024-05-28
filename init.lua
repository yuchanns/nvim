vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
--[[ vim.opt.spell = true
vim.opt.spelllang = "en_us,cjk" ]]
if vim.g.neovide then
  vim.o.guifont = "BerkeleyMono Nerd Font:h11"
end

require("core")
