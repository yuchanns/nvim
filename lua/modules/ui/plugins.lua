require("modules.ui.options")

local plugin = require("core.pack").register_plugin
local conf = require("modules.ui.config")

plugin({ "folke/tokyonight.nvim", config = conf.tokyonight })
plugin({
  "obaland/vfiler.vim",
  requires = { "obaland/vfiler-column-devicons" },
  config = conf.vfilter,
})
plugin({ "goolord/alpha-nvim", requires = { "kyazdani42/nvim-web-devicons" }, config = conf.alpha })
plugin({ "akinsho/nvim-bufferline.lua", config = conf.nvim_bufferline })
