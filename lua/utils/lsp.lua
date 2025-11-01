local M = {}

--- @param name string
--- @param config vim.lsp.Config | nil
function M.config(name, config)
    if config then vim.lsp.config(name, config) end
    vim.lsp.enable(name)
end

return M
