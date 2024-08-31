local system = require("utils.system")

local M = {}

function M.setup()
  if not system.is_executable("typescript-language-server") then
    return
  end
  local lspconfig = require("lspconfig")
  lspconfig["ts_ls"].setup({})
end

return M
