local system = require "utils.system"
local lsp = require "utils.lsp"

if not system.is_executable "emmylua_ls" then
    return
end

lsp.config "emmylua_ls"
