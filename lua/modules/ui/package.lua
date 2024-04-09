require("modules.ui.options")

local package = require("core.pack").package
local conf = require("modules.ui.config")

package({ "folke/tokyonight.nvim", config = conf.tokyonight })
--[[ package({
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = conf.catppuccin,
}) ]]
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
    { "JMarkin/nvim-tree.lua-float-preview", lazy = true },
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
  main = "ibl",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    { "hiphish/rainbow-delimiters.nvim", config = conf.rainbow_delimiters },
  },
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
package({ "folke/lsp-colors.nvim", config = conf.colors })
package({ "nvim-lua/lsp-status.nvim" })
package({ "nvim-zh/colorful-winsep.nvim", config = conf.winsep })
-- package({ "Wansmer/symbol-usage.nvim", config = conf.usage })
