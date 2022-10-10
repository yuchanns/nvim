-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require("core.pack").register_plugin
local conf = require("modules.completion.config")

plugin({
  "glepnir/lspsaga.nvim",
  config = conf.lspsaga,
  commit = "014aeb8be75d927960914d442bf81ada4e24295b",
})

plugin({ "hrsh7th/nvim-compe", config = conf.compe })
