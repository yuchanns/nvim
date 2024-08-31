return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      { "neovim/nvim-lspconfig" },
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        -- "gopls",
        -- "pylsp",
        -- "pyright",
        -- "typst_lsp",
        -- "tsserver",
        -- "bufls",
        -- "jdtls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig", config = function()
      require("lsp.luals").setup()
    end,
  }
}
