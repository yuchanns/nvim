local fn, uv = vim.fn, vim.uv
local system = require("utils.system")

if not system.is_executable("jinja-lsp") then return end
vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})
local lspconfig = require("lspconfig")
lspconfig["jinja_lsp"].setup({})
