-- Use space as leader key
vim.g.mapleader = " "

local keymap = require("core.keymap")
local map = keymap.map
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

local function t(key)
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

-- usage of plugins
map({
  -- bufferline
  { "n", "bb", cmd("BufferLinePick"), opts(noremap, silent) },
  { "n", "bc", cmd("BufferLinePickClose"), opts(noremap, silent) },
  { "n", "bd", cmd("BufferLineSortByDirectory"), opts(noremap, silent) },
  { "n", "be", cmd("BufferLineSortByExtension"), opts(noremap, silent) },
  { "n", "b[", cmd("BufferLineCyclePrev"), opts(noremap, silent) },
  { "n", "b]", cmd("BufferLineCycleNext"), opts(noremap, silent) },
  -- toggleterm
  { "n", "<Leader>t", cmd("exe v:count1 . 'ToggleTerm size=10 direction=horizontal'") },
  { "t", "<Esc>", t("<C-\\><C-n>"), opts(noremap, silent) },
  { "n", "<Leader>l", cmd("Lazygit"), opts(noremap) },
  -- code navigation
  { "n", "ga", cmd("lua require('lspsaga.codeaction').code_action()"), opts(noremap, silent) },
  {
    "n",
    "gi",
    cmd("lua require('telescope.builtin').lsp_implementations()"),
    opts(noremap, silent),
  },
  { "n", "gr", cmd("lua vim.lsp.buf.references()"), opts(noremap, silent) },
  { "n", "gd", cmd("lua vim.lsp.buf.definition()"), opts(noremap, silent) },
  { "n", "gs", cmd("lua vim.lsp.buf.document_symbol()"), opts(noremap, silent) },
  { "n", "gR", cmd("TroubleToggle lsp_references"), opts(noremap, silent) },
  { "n", "gh", cmd("lua require'lspsaga.finder'.lsp_finder()"), opts(noremap, silent) },
  { "n", "gm", cmd("lua require'telescope'.extensions.goimpl.goimpl{}"), opts(noremap, silent) },
  { "n", "gn", cmd("lua require('lspsaga.rename').lsp_rename()"), opts(noremap, silent) },
  { "n", "gf", cmd("lua vim.lsp.buf.formatting()"), opts(noremap, silent) },
  { "n", "K", cmd("lua require('lspsaga.hover').render_hover_doc()"), opts(noremap, silent) },
  -- debug
  { "n", "dc", cmd("lua require('dap').continue()"), opts(noremap, silent) },
  { "n", "di", cmd("lua require('dap').step_over()"), opts(noremap, silent) },
  { "n", "dn", cmd("lua require('dap').step_into()"), opts(noremap, silent) },
  { "n", "do", cmd("lua require('dap').step_out()"), opts(noremap, silent) },
  { "n", "db", cmd("lua require('dap').toggle_breakpoint()"), opts(noremap, silent) },
  { "n", "dr", cmd("lua require('dap').repl.open()"), opts(noremap, silent) },
})
