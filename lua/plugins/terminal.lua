local keymap = require("core.keymap")
local nmap = keymap.nmap
local cmd = keymap.cmd
local tmap = keymap.tmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts

local function t(key)
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

tmap({ "<Esc>", t("<C-\\><C-n>"), opts(noremap, silent) })

nmap({
  "<Leader>t",
  cmd("exe v:count1 . 'ToggleTerm size=10 direction=horizontal'"),
  opts(noremap, silent),
})

local shell = "/bin/bash"
if vim.fn.has("win32") == 1 then
  shell = "powershell"
end

return {
  "akinsho/toggleterm.nvim", opts = {
    shell = shell
  },
}
