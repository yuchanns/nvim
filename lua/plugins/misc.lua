local keymap = require("core.keymap")
local nmap = keymap.nmap
local cmd = keymap.cmd
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts

nmap({
  { "<Leader>v", cmd("vsplit"), opts(noremap, silent) },
  { "<Leader>s", cmd("split"), opts(noremap, silent) },
  {
    "s",
    function()
      require("flash").jump()
    end,
    opts(noremap, silent),
  }
})

return {
  {
    "Pocco81/auto-save.nvim", opts = {
      enabled = true,
      execution_message = { message = "" },
    },
    branch = "dev",
  },
  { "windwp/nvim-autopairs", opts = {} },
  {
    "karb94/neoscroll.nvim", opts = {
      mappings = {
        "<C-u>",
        "<C-d>",
      },
    },
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "folke/flash.nvim", opts = {},
    event = "VeryLazy",
  }
}
