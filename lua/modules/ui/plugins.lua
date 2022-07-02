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
plugin({
  "nvim-lualine/lualine.nvim",
  requires = { "kyazdani42/nvim-web-devicons", opt = true },
  config = conf.lualine,
})
plugin({
  "lukas-reineke/indent-blankline.nvim",
  config = conf.indent_blanklinke,
  requires = { "nvim-treesitter/nvim-treesitter" },
  after = "nvim-treesitter",
})
plugin({ "danilamihailov/beacon.nvim" })
plugin({ "famiu/bufdelete.nvim" })
plugin({
  "rcarriga/nvim-dap-ui",
  config = conf.dapui,
  requires = { "mfussenegger/nvim-dap" },
})
plugin({ "rcarriga/nvim-notify", config = conf.notify })
plugin({
  "p00f/nvim-ts-rainbow",
  requires = { "nvim-treesitter/nvim-treesitter" },
  after = "nvim-treesitter",
})
plugin({ "folke/lsp-colors.nvim", config = conf.colors })
plugin({ "nvim-lua/lsp-status.nvim" })
