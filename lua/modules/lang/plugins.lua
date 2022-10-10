-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require("core.pack").register_plugin
local conf = require("modules.lang.config")

plugin({
  "nvim-treesitter/nvim-treesitter",
  event = "BufRead",
  run = ":TSUpdate",
  after = "telescope.nvim",
  config = conf.nvim_treesitter,
})

plugin({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })

plugin({
  "neovim/nvim-lspconfig",
  requires = {
    { "RRethy/vim-illuminate" },
    { "ray-x/lsp_signature.nvim" },
    -- { "stevearc/aerial.nvim" },
    { "crispgm/nvim-go" },
    { "simrat39/rust-tools.nvim" },
    { "rhysd/vim-go-impl" },
    { "rust-lang/rust.vim" },
    { "ckipp01/stylua-nvim" },
    {
      "yuchanns/goimpl.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
        { "nvim-telescope/telescope.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
      after = "telescope.nvim",
    },
  },
  config = conf.nvim_lspconfig,
})
plugin({ "mfussenegger/nvim-dap", config = conf.dap })
plugin({ "yuchanns/phpfmt.nvim", config = conf.phpfmt })
plugin({ "yuchanns/shfmt.nvim", config = conf.shfmt })
