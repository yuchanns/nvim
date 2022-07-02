-- Use space as leader key
vim.g.mapleader = " "

local keymap = require("core.keymap")
local map = keymap.map
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

-- usage of plugins
map({
  -- bufferline
  { "n", "bb", cmd("BufferLinePick"), opts(noremap, silent) },
  { "n", "bc", cmd("BufferLinePickClose"), opts(noremap, silent) },
  { "n", "bd", cmd("BufferLineSortByDirectory"), opts(noremap, silent) },
  { "n", "be", cmd("BufferLineSortByExtension"), opts(noremap, silent) },
  { "n", "b[", cmd("BufferLineCyclePrev"), opts(noremap, silent) },
  { "n", "b]", cmd("BufferLineCycleNext"), opts(noremap, silent) },
})
