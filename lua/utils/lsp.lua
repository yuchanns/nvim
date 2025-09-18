local M = {}

--- @param name string
--- @param config vim.lsp.Config
function M.config(name, config)
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

return M
