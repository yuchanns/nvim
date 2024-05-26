local package = require("core.pack").package
local conf = require("modules.lang.config")

package({
  "nvim-treesitter/nvim-treesitter",
  event = "BufRead",
  build = ":TSUpdate",
  dependencies = { { "telescope.nvim" } },
  config = conf.nvim_treesitter,
})

package({ "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { { "nvim-treesitter" } } })

package({
  "neovim/nvim-lspconfig",
  dependencies = {
    { "RRethy/vim-illuminate", config = conf.illuminate },
    { "crispgm/nvim-go" },
    { "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" }, lazy = false },
    { "rhysd/vim-go-impl" },
    { "rust-lang/rust.vim" },
    { "ckipp01/stylua-nvim" },
    {
      "edolphin-ydf/goimpl.nvim",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
        { "nvim-telescope/telescope.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
    },
    { "mfussenegger/nvim-jdtls" },
  },
  config = conf.nvim_lspconfig,
})
package({ "mfussenegger/nvim-dap", config = conf.dap })
package({ "yuchanns/phpfmt.nvim", config = conf.phpfmt })
package({ "yuchanns/shfmt.nvim", config = conf.shfmt })
package({
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "neovim/nvim-lspconfig" },
  },
  config = conf.mason,
})

package({
  "MysticalDevil/inlay-hints.nvim",
  event = "LspAttach",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("inlay-hints").setup()
  end,
})
