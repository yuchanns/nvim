local package = require("core.pack").package
local conf = require("modules.completion.config")

package({
  "glepnir/lspsaga.nvim",
  config = conf.lspsaga,
  event = "LspAttach",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
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
    { "hrsh7th/cmp-cmdline" },
    { "uga-rosa/cmp-dictionary" },
    { "onsails/lspkind.nvim" },
    { "f3fora/cmp-spell" },
    { "ekalinin/Dockerfile.vim" },
  },
})

package({
  "dpayne/CodeGPT.nvim",
  config = conf.codegpt,
})

package({
  "yuchanns/avante_bedrock.nvim",
  build = "make",
  config = function()
    require("avante_bedrock").setup()
    require("avante").setup(conf.avante())
  end,
  dependencies = {
    "yetone/avante.nvim",
    build = "make",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below is optional, make sure to setup it properly if you have lazy=true
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
})
