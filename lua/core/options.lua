local opt, uv, fn, g, cmd = vim.opt, vim.loop, vim.fn, vim.g, vim.cmd
local cache_dir = vim.env.HOME .. "/.cache/nvim"
local keymap = require("core.keymap")
local nmap = keymap.nmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts

opt.termguicolors = true
opt.hidden = true
opt.magic = true
opt.virtualedit = "block"
opt.clipboard = "unnamedplus"
opt.wildignorecase = true
opt.swapfile = false
opt.directory = cache_dir .. "swap/"
opt.undodir = cache_dir .. "undo/"
opt.backupdir = cache_dir .. "backup/"
opt.viewdir = cache_dir .. "view/"
opt.spellfile = cache_dir .. "spell/en.uft-8.add"
opt.history = 2000
opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.updatetime = 100
opt.redrawtime = 1500
opt.ignorecase = true
opt.smartcase = true
opt.infercase = true

if vim.fn.executable("rg") == 1 then
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end

opt.completeopt = "menu,menuone,noselect"
opt.showmode = false
opt.shortmess = "aoOTIcF"
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.ruler = false
opt.showtabline = 0
opt.winwidth = 30
opt.pumheight = 15
opt.showcmd = false

opt.cmdheight = 0
opt.laststatus = 3
opt.list = true
opt.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←"
opt.pumblend = 10
opt.winblend = 10
opt.undofile = true

opt.smarttab = true
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2

-- wrap
opt.linebreak = true
opt.whichwrap = "h,l,<,>,[,],~"
opt.breakindentopt = "shift:2,min:20"
opt.showbreak = "↳ "

opt.foldlevelstart = 99
opt.foldmethod = "marker"

opt.number = true
opt.signcolumn = "yes:1"
opt.spelloptions = "camel"

opt.textwidth = 100

if uv.os_uname().sysname == "Darwin" then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
end

opt.laststatus = 3
opt.splitkeep = "screen"

opt.splitbelow = true
opt.splitright = true

opt.backup = false
opt.swapfile = false
opt.writebackup = false

opt.autoindent = true
opt.smartindent = true
opt.cindent = true
opt.expandtab = true

opt.number = true
opt.termguicolors = true

opt.updatetime = 400
opt.hidden = true
opt.wrap = true
opt.fileencoding = "utf-8"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.belloff = "all"
opt.fileformat = "unix"
opt.fileformats = "unix,dos"

if fn.has("win32") ~= 1 then
  opt.shell = "bash"
end

vim.wo.signcolumn = "yes:1"
cmd("set mouse=")
cmd("let &fcs='eob: '") -- hide tilde sign on blank lines

if fn.has("win32") == 1 then
  nmap({ "v", "<C-q>", opts(noremap, silent) })
end

g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

if g.neovide then
  vim.o.guifont = "BerkeleyMono Nerd Font:h11"
end
