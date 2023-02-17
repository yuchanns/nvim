-- Use space as leader key
vim.g.mapleader = " "

local keymap = require("core.keymap")
local nmap = keymap.nmap
local tmap = keymap.tmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd
local hop = require("hop")

local function t(key)
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

-- usage of plugins
nmap({
  -- bufferline
  { "bb", cmd("BufferLinePick"), opts(noremap, silent) },
  { "bc", cmd("BufferLinePickClose"), opts(noremap, silent) },
  { "bd", cmd("BufferLineSortByDirectory"), opts(noremap, silent) },
  { "be", cmd("BufferLineSortByExtension"), opts(noremap, silent) },
  { "b[", cmd("BufferLineCyclePrev"), opts(noremap, silent) },
  { "b]", cmd("BufferLineCycleNext"), opts(noremap, silent) },
  -- toggleterm
  { "<Leader>t", cmd("exe v:count1 . 'ToggleTerm size=10 direction=horizontal'") },
  { "<Leader>l", cmd("Lazygit"), opts(noremap) },
  -- code navigation
  { "ga", cmd("lua require('lspsaga.codeaction').code_action()"), opts(noremap, silent) },
  {
    "gi",
    cmd("lua require('telescope.builtin').lsp_implementations()"),
    opts(noremap, silent),
  },
  { "gr", cmd("lua vim.lsp.buf.references()"), opts(noremap, silent) },
  { "gd", cmd("lua vim.lsp.buf.definition()"), opts(noremap, silent) },
  { "gs", cmd("lua vim.lsp.buf.document_symbol()"), opts(noremap, silent) },
  { "gR", cmd("TroubleToggle lsp_references"), opts(noremap, silent) },
  { "gh", cmd("lua require'lspsaga.finder'.lsp_finder()"), opts(noremap, silent) },
  { "gm", cmd("lua require'telescope'.extensions.goimpl.goimpl{}"), opts(noremap, silent) },
  { "gn", cmd("lua require('lspsaga.rename').lsp_rename()"), opts(noremap, silent) },
  { "gf", cmd("lua vim.lsp.buf.format { async = true }"), opts(noremap, silent) },
  { "K", cmd("lua require('lspsaga.hover').render_hover_doc()"), opts(noremap, silent) },
  -- debug
  { "dc", cmd("lua require('dap').continue()"), opts(noremap, silent) },
  { "di", cmd("lua require('dap').step_over()"), opts(noremap, silent) },
  { "dn", cmd("lua require('dap').step_into()"), opts(noremap, silent) },
  { "do", cmd("lua require('dap').step_out()"), opts(noremap, silent) },
  { "db", cmd("lua require('dap').toggle_breakpoint()"), opts(noremap, silent) },
  { "dr", cmd("lua require('dap').repl.open()"), opts(noremap, silent) },
  -- window resize
  { "=", cmd("exe 'resize +1.5'"), opts(noremap, silent) },
  { "-", cmd("exe 'resize -1.5'"), opts(noremap, silent) },
  { "+", cmd("exe 'vertical resize +1.5'"), opts(noremap, silent) },
  { "_", cmd("exe 'vertical resize -1.5'"), opts(noremap, silent) },
  -- code structure
  --[[ { "n", "{", cmd("AerialPrev"), opts(noremap, silent) },
  { "n", "}", cmd("AerialNext"), opts(noremap, silent) }, ]]
  -- diagnostics
  { "[e", cmd("lua require('lspsaga.diagnostic').goto_prev()"), opts(noremap, silent) },
  { "]e", cmd("lua require('lspsaga.diagnostic').goto_next()"), opts(noremap, silent) },
  {
    "<Leader>e",
    cmd("lua require('lspsaga.diagnostic').show_line_diagnostics()"),
    opts(noremap, silent),
  },
  -- trouble
  {
    "<Leader>xx",
    cmd("TroubleToggle"),
    opts(noremap, silent),
  },
  {
    "<Leader>xw",
    cmd("TroubleToggle workspace_diagnostics"),
    opts(noremap, silent),
  },
  {
    "<Leader>xd",
    cmd("TroubleToggle document_diagnostics"),
    opts(noremap, silent),
  },
  {
    "<Leader>xq",
    cmd("TroubleToggle quickfix"),
    opts(noremap, silent),
  },
  {
    "<Leader>xl",
    cmd("TroubleToggle loclist"),
    opts(noremap, silent),
  },
  {
    "<Leader>xt",
    cmd("TodoTelescope"),
    opts(normap, silent),
  },
  -- split view
  { "<Leader>v", cmd("vsplit"), opts(noremap, silent) },
  { "<Leader>s", cmd("split"), opts(noremap, silent) },
  -- hop
  {
    "ft",
    function()
      hop.hint_anywhere({
        current_line_onply = false,
      })
    end,
    { remap = true },
  },
})

tmap({ "<Esc>", t("<C-\\><C-n>"), opts(noremap, silent) })
