local rainbow_highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      sections = {
        lualine_x = { "encoding", "fileformat", "filetype" },
      },
      options = {
        icons_enabled = true,
        theme = "auto",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append("space:⋅")
      local highlight = {
        "IndentRainbowRed",
        "IndentRainbowYellow",
        "IndentRainbowBlue",
        "IndentRainbowCyan",
      }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        vim.api.nvim_set_hl(0, "IndentRainbowRed", { bg = "#373043" })
        vim.api.nvim_set_hl(0, "IndentRainbowYellow", { bg = "#373744" })
        vim.api.nvim_set_hl(0, "IndentRainbowBlue", { bg = "#2e384a" })
        vim.api.nvim_set_hl(0, "IndentRainbowCyan", { bg = "#2e3848" })
      end)
      require("ibl").setup({
        indent = {
          highlight = rainbow_highlight,
          char = "",
          tab_char = "",
        },
        whitespace = {
          highlight = highlight,
          remove_blankline_trail = true,
        },
        scope = {
          enabled = true,
          highlight = rainbow_highlight,
          show_start = false,
          show_end = false,
        },
        exclude = {
          filetypes = {
            "startify",
            "dashboard",
            "dotooagenda",
            "log",
            "fugitive",
            "gitcommit",
            "packer",
            "vimwiki",
            "markdown",
            "json",
            "txt",
            "vista",
            "help",
            "todoist",
            "NvimTree",
            "peekaboo",
            "git",
            "TelescopePrompt",
            "undotree",
            "flutterToolsOutline",
            "", -- for all buffers without a file type
          },
          buftypes = { "terminal", "nofile" },
        },
      })
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
    event = "BufRead",
    main = "ibl",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "hiphish/rainbow-delimiters.nvim",
        config = function()
          local rainbow_delimiters = require("rainbow-delimiters")

          vim.g.rainbow_delimiters = {
            strategy = {
              [""] = rainbow_delimiters.strategy["global"],
              vim = rainbow_delimiters.strategy["local"],
            },
            query = {
              [""] = "rainbow-delimiters",
              lua = "rainbow-blocks",
            },
            highlight = rainbow_highlight,
          }
        end,
      },
    },
  },
}
