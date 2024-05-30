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
    {
      "nvim-telescope/telescope-frecency.nvim",
      config = conf.frecency,
      dependencies = { { "kkharji/sqlite.lua" } },
    },
    { "Marskey/telescope-sg" },
  },
})
package({ "windwp/nvim-autopairs", config = conf.autopairs })
package({ "Pocco81/auto-save.nvim", config = conf.autosave, branch = "dev" })
package({
  "karb94/neoscroll.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = conf.neoscroll,
})
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
package({
  "folke/flash.nvim",
  event = "VeryLazy",
  config = conf.flash,
})
-- session
package({
  "folke/persistence.nvim",
  event = { "BufReadPre" },
  config = conf.persistence,
})

package({
  "caenrique/swap-buffers.nvim",
  config = function()
    require("swap-buffers").setup()
  end,
})

-- test
package({
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-go",
    "rouge8/neotest-rust",
  },
  config = conf.neotest,
})

-- org mode
package({
  "nvim-orgmode/orgmode",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", lazy = true },
  },
  event = "VeryLazy",
  config = conf.orgmode,
})

-- lazygit
package({
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = conf.lazygit,
})

-- copy code reference
package({
  "yuchanns/ccr.nvim",
})

-- yazi
package({
  "mikavilpas/yazi.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>ff",
      function()
        require("yazi").yazi()
      end,
      desc = "Open the file manager",
    },
    {
      -- Open in the current working directory
      "<leader>cw",
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      desc = "Open the file manager in nvim's working directory",
    },
  },
  ---@type YaziConfig
  opts = {
    open_for_directories = false,
  },
})
