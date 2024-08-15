-- Use space as leader key
vim.g.mapleader = " "

local keymap = require("core.keymap")
local nmap = keymap.nmap
local tmap = keymap.tmap
local vmap = keymap.vmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd
local flash = require("flash")

local function t(key)
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

-- usage of plugins
nmap({
  -- bufferline
  {
    "bb",
    cmd("BufferLinePick"),
    opts(noremap, silent),
  },
  {
    "bc",
    cmd("BufferLinePickClose"),
    opts(noremap, silent),
  },
  {
    "bo",
    cmd("BufferLineCloseOthers"),
    opts(noremap, silent),
  },
  {
    "bd",
    cmd("BufferLineSortByDirectory"),
    opts(noremap, silent),
  },
  {
    "be",
    cmd("BufferLineSortByExtension"),
    opts(noremap, silent),
  },
  {
    "b[",
    cmd("BufferLineCyclePrev"),
    opts(noremap, silent),
  },
  {
    "b]",
    cmd("BufferLineCycleNext"),
    opts(noremap, silent),
  },
  -- toggleterm
  { "<Leader>t", cmd("exe v:count1 . 'ToggleTerm size=10 direction=horizontal'") },
  { "<Leader>l", cmd("LazyGit"), opts(noremap) },
  { "<Leader>d", cmd("LazyDocker"), opts(noremap) },
  -- code navigation
  {
    "ga",
    cmd("Lspsaga code_action"),
    opts(noremap, silent),
  },
  {
    "gi",
    cmd("lua require('telescope.builtin').lsp_implementations()"),
    opts(noremap, silent),
  },
  { "gr", cmd("lua vim.lsp.buf.references()"), opts(noremap, silent) },
  { "gd", cmd("lua vim.lsp.buf.definition()"), opts(noremap, silent) },
  { "gs", cmd("lua vim.lsp.buf.document_symbol()"), opts(noremap, silent) },
  { "gR", cmd("Trouble lsp_references toggle"), opts(noremap, silent) },
  { "gh", cmd("Lspsaga finder ref+def"), opts(noremap, silent) },
  { "gm", cmd("lua require'telescope'.extensions.goimpl.goimpl{}"), opts(noremap, silent) },
  { "gn", cmd("Lspsaga rename"), opts(noremap, silent) },
  { "gf", cmd("lua vim.lsp.buf.format { async = true }"), opts(noremap, silent) },
  { "K", cmd("Lspsaga hover_doc"), opts(noremap, silent) },
  -- debug
  { "dc", cmd("lua require('dap').continue()"), opts(noremap, silent) },
  { "di", cmd("lua require('dap').step_over()"), opts(noremap, silent) },
  { "dn", cmd("lua require('dap').step_into()"), opts(noremap, silent) },
  { "do", cmd("lua require('dap').step_out()"), opts(noremap, silent) },
  { "db", cmd("lua require('dap').toggle_breakpoint()"), opts(noremap, silent) },
  { "dr", cmd("lua require('dap').repl.open()"), opts(noremap, silent) },
  -- unit tests
  { "du", cmd("NTestOutput"), opts(noremap, silent) },
  -- window resize
  { "=", cmd("exe 'resize +1.5'"), opts(noremap, silent) },
  { "-", cmd("exe 'resize -1.5'"), opts(noremap, silent) },
  { "+", cmd("exe 'vertical resize +1.5'"), opts(noremap, silent) },
  { "_", cmd("exe 'vertical resize -1.5'"), opts(noremap, silent) },
  -- code structure
  { "<Leader>a", cmd("Lspsaga outline"), opts(noremap, silent) },
  -- diagnostics
  { "[e", cmd("Lspsaga diagnostic_jump_prev"), opts(noremap, silent) },
  { "]e", cmd("Lspsaga diagnostic_jump_next"), opts(noremap, silent) },
  {
    "<Leader>e",
    cmd("Lspsaga show_line_diagnostics"),
    opts(noremap, silent),
  },
  -- trouble
  {
    "<Leader>xx",
    cmd("Trouble diagnostics toggle"),
    opts(noremap, silent),
  },
  {
    "<Leader>xq",
    cmd("Trouble quickfix toggle"),
    opts(noremap, silent),
  },
  {
    "<Leader>xt",
    cmd("Trouble todo toggle"),
    opts(noremap, silent),
  },
  -- split view
  { "<Leader>v", cmd("vsplit"), opts(noremap, silent) },
  { "<Leader>s", cmd("split"), opts(noremap, silent) },
  {
    "s",
    function()
      flash.jump()
    end,
    opts(noremap, silent),
  },
  -- buffer swap
  { "<C-h>", cmd("lua require('swap-buffers').swap_buffers('h')"), opts(noremap, silent) },
  { "<C-j>", cmd("lua require('swap-buffers').swap_buffers('j')"), opts(noremap, silent) },
  { "<C-k>", cmd("lua require('swap-buffers').swap_buffers('k')"), opts(noremap, silent) },
  { "<C-l>", cmd("lua require('swap-buffers').swap_buffers('l')"), opts(noremap, silent) },
  -- copy code reference
  { "<Leader>c", cmd([[lua require("ccr").copy_rel_path_and_line()]]), opts(noremap, silent) },
})

vmap({ -- codegp
  { "<Leader>ep", cmd("'<,'>Chat polish"), opts(noremap, silent) },
  { "<Leader>et", cmd("'<,'>Chat translate"), opts(noremap, silent) },
  { "<Leader>ec", cmd("'<,'>Chat completion"), opts(noremap, silent) },
  { "<Leader>ed", cmd("'<,'>Chat doc"), opts(noremap, silent) },
})

tmap({ "<Esc>", t("<C-\\><C-n>"), opts(noremap, silent) })
