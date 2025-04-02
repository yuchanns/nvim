local keymap = require("utils.keymap")
local nmap = keymap.nmap
local cmd = keymap.cmd
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local autocmd = require("utils.autocmd")
local loader = require("utils.loader")

autocmd.lsp_attach(function(client, bufnr) require("illuminate").on_attach(client, bufnr) end)

autocmd.user_pattern("VeryLazy", loader.callback_load_mods({ "lsp", "lsp.setup" }))

autocmd.user_cmd("LspRestartHint", function()
  vim.cmd("LspRestart")
  vim.notify("LSP Restarted", vim.log.levels.INFO, { title = "LSP" })
end, {})

-- lspsaga
vim.api.nvim_set_hl(0, "SagaBeacon", { link = "FinderPreview" })
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "💡",
    },
  },
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
  { "ga", cmd("Lspsaga code_action"), opts(noremap, silent) },
  { "gi", cmd("lua require('telescope.builtin').lsp_implementations()"), opts(noremap, silent) },
  { "gr", cmd("lua vim.lsp.buf.references()"), opts(noremap, silent) },
  { "gd", cmd("lua vim.lsp.buf.definition()"), opts(noremap, silent) },
  { "gs", cmd("lua vim.lsp.buf.document_symbol()"), opts(noremap, silent) },
  { "gR", cmd("Trouble lsp_references toggle"), opts(noremap, silent) },
  { "gh", cmd("Lspsaga finder ref+def"), opts(noremap, silent) },
  { "gm", cmd("lua require'telescope'.extensions.goimpl.goimpl{}"), opts(noremap, silent) },
  { "gn", cmd("Lspsaga rename"), opts(noremap, silent) },
  { "gf", cmd("lua vim.lsp.buf.format { async = true }"), opts(noremap, silent) },
  { "K", cmd("Lspsaga hover_doc"), opts(noremap, silent) },
  { "[e", cmd("Lspsaga diagnostic_jump_prev"), opts(noremap, silent) },
  { "]e", cmd("Lspsaga diagnostic_jump_next"), opts(noremap, silent) },
  { "<Leader>e", cmd("Lspsaga show_line_diagnostics"), opts(noremap, silent) },
  { "<Leader>a", cmd("Lspsaga outline"), opts(noremap, silent) },
  { "<Leader>r", cmd("LspRestartHint"), opts(noremap, silent) },
})

return {
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = "BufRead" },
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter" } },
  {
    "williamboman/mason-lspconfig.nvim",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "pylsp",
        "pyright",
        -- "typst_lsp",
        "ts_ls",
        -- "bufls",
        -- "jdtls",
        "glsl_analyzer",
        "jinja_lsp",
      },
    },
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      { "neovim/nvim-lspconfig", dependencies = { "ckipp01/stylua-nvim" } },
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
    event = "VeryLazy",
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
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    lazy = false,
    dependencies = { "rust-lang/rust.vim" },
  },
  { "RRethy/vim-illuminate" },
}
