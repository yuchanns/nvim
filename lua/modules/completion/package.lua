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
  },
})
