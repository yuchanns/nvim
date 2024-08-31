return {
  {
    "mikavilpas/yazi.nvim",
    opts = {
      open_for_directories = false,
    },
    dependencies = { "nvim-lua/plenary.nvim" },
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
  }
}
