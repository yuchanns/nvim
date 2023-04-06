require("keymap.config")
local keymap = require("core.keymap")
local nmap = keymap.nmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

-- usage of plugins
nmap({
  -- vfilter
  { "<Leader>ff", cmd("lua require('vfiler').start()"), opts(noremap, silent) },
  {
    "<Leader>fa",
    cmd("Telescope live_grep"),
    opts(noremap, silent),
  },
  { "<Leader>fp", cmd("Telescope neoclip"), opts(noremap, silent) },
  {
    "<Leader>fs",
    cmd("Telescope lsp_dynamic_workspace_symbols"),
    opts(noremap, silent),
  },
  {
    "<Leader>fh",
    cmd("Telescope frecency workspace=CWD"),
    opts(noremap, silent),
  },
})
