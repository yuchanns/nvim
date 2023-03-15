local package = require("core.pack").package
local conf = require("modules.completion.config")

package({
  "glepnir/lspsaga.nvim",
  config = conf.lspsaga,
  commit = "014aeb8be75d927960914d442bf81ada4e24295b",
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
    { "hrsh7th/cmp-cmdline" },
    { "uga-rosa/cmp-dictionary" },
  },
})

package({
  "yuchanns/CodeGPT.nvim",
  config = conf.codegpt,
  commit = "40ef8a532e40a2cd31ff8e7610c74eed66c2229a",
})
