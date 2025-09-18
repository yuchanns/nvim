local system = require("utils.system")
local lsp = require("utils.lsp")

if not system.is_executable("clangd") then return end

lsp.config("clangd", {
  cmd = { "clangd", "--offset-encoding=utf-16" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})
