local plugin = require("core.pack").register_plugin
local conf = require("modules.tools.config")

plugin({
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  config = conf.telescope,
  requires = {
    { "nvim-lua/popup.nvim", opt = true },
    { "nvim-lua/plenary.nvim", opt = true },
    { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
    { "nvim-telescope/telescope-file-browser.nvim" },
    {
      "AckslD/nvim-neoclip.lua",
      config = conf.neoclip,
    },
  },
})

plugin({ "windwp/nvim-autopairs", config = conf.autopairs })
