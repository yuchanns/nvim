local system = require "utils.system"
local lsp = require "utils.lsp"

local lspconfig = require "lspconfig"

if not system.is_executable "sourcekit-lsp" then return end

lsp.config("sourcekit", {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
})
