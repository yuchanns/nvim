require("modules.ui.options")

local package = require("core.pack").package
local conf = require("modules.ui.config")

package({ "folke/tokyonight.nvim", config = conf.tokyonight })
package({
  "obaland/vfiler.vim",
  dependencies = { "obaland/vfiler-column-devicons" },
  config = conf.vfilter,
})
package({
  "goolord/alpha-nvim",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = conf.alpha,
})
package({
  "akinsho/nvim-bufferline.lua",
  event = "BufRead",
  config = conf.nvim_bufferline,
  dependencies = { { "kyazdani42/nvim-web-devicons" } },
})
package({
  "nvim-lualine/lualine.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
  config = conf.lualine,
})
package({
  "lukas-reineke/indent-blankline.nvim",
  event = "BufRead",
  config = conf.indent_blanklinke,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
})
package({ "danilamihailov/beacon.nvim" })
package({ "famiu/bufdelete.nvim" })
package({
  "rcarriga/nvim-dap-ui",
  config = conf.dapui,
  dependencies = { "mfussenegger/nvim-dap" },
})
package({ "rcarriga/nvim-notify", config = conf.notify })
package({
  "p00f/nvim-ts-rainbow",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
})
package({ "folke/lsp-colors.nvim", config = conf.colors })
package({ "nvim-lua/lsp-status.nvim" })
