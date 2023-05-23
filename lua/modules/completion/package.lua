local package = require("core.pack").package
local conf = require("modules.completion.config")

package({
  "glepnir/lspsaga.nvim",
  config = conf.lspsaga,
  event = "LspAttach",
  dependencies = {
    { "kyazdani42/nvim-web-devicons" },
    --Please make sure you install markdown and markdown_inline parser
    { "nvim-treesitter/nvim-treesitter" },
  },
})

package({
  "hrsh7th/nvim-cmp",
  config = conf.compe,
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "SirVer/ultisnips" },
    { "hrsh7th/cmp-nvim-lua" },
    { "quangnguyen30192/cmp-nvim-ultisnips" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    -- { "hrsh7th/cmp-cmdline" },
    { "uga-rosa/cmp-dictionary" },
  },
})

package({
  "dpayne/CodeGPT.nvim",
  config = conf.codegpt,
})
