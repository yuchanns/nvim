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
    { "nvim-telescope/telescope-file-browser.nvim", opt = true },
    {
      "AckslD/nvim-neoclip.lua",
      config = conf.neoclip,
    },
  },
})
plugin({ "windwp/nvim-autopairs", config = conf.autopairs })
plugin({ "Pocco81/AutoSave.nvim", config = conf.autosave })
plugin({ "karb94/neoscroll.nvim", config = conf.neoscroll })
plugin({ "akinsho/nvim-toggleterm.lua", config = conf.toggleterm })
plugin({ "tpope/vim-surround" })
plugin({ "b3nj5m1n/kommentary" })
plugin({ "FotiadisM/tabset.nvim", config = conf.tabset })
plugin({ "wakatime/vim-wakatime" })
plugin({ "mg979/vim-visual-multi" })
plugin({ "sindrets/diffview.nvim", config = conf.diffview, requires = { "nvim-lua/plenary.nvim" } })
plugin({
  "lewis6991/gitsigns.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = conf.gitsigns,
})
plugin({ "folke/trouble.nvim", config = conf.trouble })
