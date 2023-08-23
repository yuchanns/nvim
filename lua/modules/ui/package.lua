require("modules.ui.options")

local package = require("core.pack").package
local conf = require("modules.ui.config")

-- package({ "folke/tokyonight.nvim", config = conf.tokyonight })
package({
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = conf.catppuccin,
})
--[[ package({
  "obaland/vfiler.vim",
  dependencies = {
    { "obaland/vfiler-column-devicons" },
    { "obaland/vfiler-patch-noice.nvim" },
  },
  config = conf.vfilter,
}) ]]
package({
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = conf.nvim_tree,
})
package({
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = conf.alpha,
})
package({
  "akinsho/nvim-bufferline.lua",
  event = "BufRead",
  config = conf.nvim_bufferline,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
})
package({
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
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
package({
  "folke/noice.nvim",
  config = conf.notify,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
})
package({
  "p00f/nvim-ts-rainbow",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
})
package({ "folke/lsp-colors.nvim", config = conf.colors })
package({ "nvim-lua/lsp-status.nvim" })
