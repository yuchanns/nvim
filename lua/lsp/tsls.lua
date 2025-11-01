local system = require "utils.system"
local lsp = require "utils.lsp"

if not system.is_executable "typescript-language-server" then return end

lsp.config("ts_ls", {})
