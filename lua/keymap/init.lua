-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT
-- recommend plugins key defines in this file

require("keymap.config")
local keymap = require("core.keymap")
local map = keymap.map
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

-- usage of plugins
map({
  -- packer
  { "n", "<Leader>pu", cmd("PackerUpdate"), opts(noremap, silent) },
  { "n", "<Leader>pi", cmd("PackerInstall"), opts(noremap, silent) },
  { "n", "<Leader>pc", cmd("PackerCompile"), opts(noremap, silent) },
  -- vfilter
  { "n", "<Leader>ff", cmd("lua require('vfiler').start()"), opts(noremap, silent) },
  {
    "n",
    "<Leader>fa",
    cmd("lua require('telescope.builtin').live_grep()"),
    opts(noremap, silent),
  },
  { "n", "<Leader>fp", cmd("Telescope neoclip"), opts(noremap, silent) },
  {
    "n",
    "<Leader>fs",
    cmd("lua require('telescope.builtin').lsp_dynamic_workspace_symbols()"),
    opts(noremap, silent),
  },
  {
    "n",
    "<Leader>fh",
    cmd("lua require('telescope.builtin').oldfiles()"),
    opts(noremap, silent),
  },
})
