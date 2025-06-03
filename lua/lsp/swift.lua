local system = require("utils.system")

local lspconfig = require("lspconfig")

if not system.is_executable("sourcekit-lsp") then return end

lspconfig["sourcekit"].setup({
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
})
