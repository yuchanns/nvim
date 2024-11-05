local keymap = require("utils.keymap")
local nmap = keymap.nmap
local cmd = keymap.cmd
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local autocmd = require("utils.autocmd")

-- lspsaga
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "Warn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "Info" })
vim.fn.sign_define("DiagnosticSignHint", { text = "💡", texthl = "Hint" })
vim.api.nvim_set_hl(0, "SagaBeacon", { link = "FinderPreview" })
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return string.format(" %s", diagnostic.message)
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        return string.format(" %s", diagnostic.message)
      elseif diagnostic.severity == vim.diagnostic.severity.INFO then
        return string.format(" %s", diagnostic.message)
      end
      return string.format("💡%s", diagnostic.message)
    end,
  },
})

nmap({
  { "ga",        cmd("Lspsaga code_action"),                                    opts(noremap, silent) },
  { "gi",        cmd("lua require('telescope.builtin').lsp_implementations()"), opts(noremap, silent) },
  { "gr",        cmd("lua vim.lsp.buf.references()"),                           opts(noremap, silent) },
  { "gd",        cmd("lua vim.lsp.buf.definition()"),                           opts(noremap, silent) },
  { "gs",        cmd("lua vim.lsp.buf.document_symbol()"),                      opts(noremap, silent) },
  { "gR",        cmd("Trouble lsp_references toggle"),                          opts(noremap, silent) },
  { "gh",        cmd("Lspsaga finder ref+def"),                                 opts(noremap, silent) },
  { "gm",        cmd("lua require'telescope'.extensions.goimpl.goimpl{}"),      opts(noremap, silent) },
  { "gn",        cmd("Lspsaga rename"),                                         opts(noremap, silent) },
  { "gf",        cmd("lua vim.lsp.buf.format { async = true }"),                opts(noremap, silent) },
  { "K",         cmd("Lspsaga hover_doc"),                                      opts(noremap, silent) },
  { "[e",        cmd("Lspsaga diagnostic_jump_prev"),                           opts(noremap, silent) },
  { "]e",        cmd("Lspsaga diagnostic_jump_next"),                           opts(noremap, silent) },
  { "<Leader>e", cmd("Lspsaga show_line_diagnostics"),                          opts(noremap, silent) },
  { "<Leader>a", cmd("Lspsaga outline"),                                        opts(noremap, silent) },
})


return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufRead",
    config = function()
      vim.api.nvim_command("set foldmethod=expr")
      vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "markdown", "markdown_inline", "vimdoc", "go", "typescript", "rust", "c", "vim", "lua", "query" },
        ignore_install = { "phpdoc" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "org" },
          disable = function(lang, bufnr)
            return lang == "javascript" and vim.api.nvim_buf_line_count(bufnr) > 1000
          end,
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = ".",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
    end
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter" } },
  {
    "williamboman/mason-lspconfig.nvim",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        -- "pylsp",
        -- "pyright",
        -- "typst_lsp",
        "ts_ls",
        -- "bufls",
        -- "jdtls",
      },
    },
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      {
        "neovim/nvim-lspconfig",
        config = function()
          require("lsp.luals").setup()
          require("lsp.tsls").setup()
          require("lsp.gopls").setup()
          require("lsp.rustls").setup()
        end
      },
    },
  },
  {
    "glepnir/lspsaga.nvim",
    opts = {
      ui = {
        winblend = 20,
        border = "rounded",
        kind = { Folder = { "  ", "Title" } },
      },
      outline = {
        win_width = 30,
        preview_width = 0.4,
        show_detail = true,
        auto_preview = true,
        auto_refresh = true,
        auto_close = true,
        auto_resize = true,
        custom_sort = nil,
        keys = {
          expand_or_jump = "o",
          quit = "q",
        },
      },
    },
    event = "LspAttach",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      -- To use ultisnips, you need to have python installed, and two modules are required:
      -- * pynvim
      -- * typing_extensions
      -- Make sure python is available in your $PATH.
      -- pyenv is recommendation.
      -- You can get the executable path by `pyenv which python` and then set it to the $PATH.
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",       -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item)
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = true,
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "ultisnips" }, -- For ultisnips users.
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "path" },
          { name = "dictionary" },
          { name = "orgmode" },
          {
            name = "spell",
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
            },
          },
        }),
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        },
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
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
  },
  { "crispgm/nvim-go" },
  { "rhysd/vim-go-impl" },
  {
    "edolphin-ydf/goimpl.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    opts = {},
    dependencies = { "neovim/nvim-lspconfig" }
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    lazy = false,
    dependencies = {
      "rust-lang/rust.vim",
    },
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      autocmd.on_lsp_attach(require("illuminate").on_attach)
    end
  }
}
