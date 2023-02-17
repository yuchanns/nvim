local package = require("core.pack").package
local conf = require("modules.tools.config")

package({
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  config = conf.telescope,
  dependencies = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzy-native.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    {
      "AckslD/nvim-neoclip.lua",
      config = conf.neoclip,
    },
  },
})
package({ "windwp/nvim-autopairs", config = conf.autopairs })
package({ "Pocco81/auto-save.nvim", config = conf.autosave })
package({ "karb94/neoscroll.nvim", config = conf.neoscroll })
package({ "akinsho/nvim-toggleterm.lua", config = conf.toggleterm })
package({ "tpope/vim-surround" })
package({ "b3nj5m1n/kommentary" })
package({ "FotiadisM/tabset.nvim", config = conf.tabset })
package({ "wakatime/vim-wakatime" })
package({ "mg979/vim-visual-multi" })
package({
  "sindrets/diffview.nvim",
  config = conf.diffview,
  dependencies = { "nvim-lua/plenary.nvim" },
})
package({
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = conf.gitsigns,
})
package({ "folke/trouble.nvim", config = conf.trouble })
-- leetcode
package({ "ianding1/leetcode.vim", config = conf.leetcode })
-- todo
package({
  "folke/todo-comments.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = conf.todo,
})
-- hop
package({ "phaazon/hop.nvim", branch = "v2", config = conf.hop })
