local system = require "utils.system"
local lsp = require "utils.lsp"

if not system.is_executable "zls" then return end

lsp.config("zls", {})
