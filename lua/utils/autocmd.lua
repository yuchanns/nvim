local M = {}

--- @param pattern string
--- @param callback fun()
function M.user_pattern(pattern, callback)
    vim.api.nvim_create_autocmd("User", {
        pattern = pattern,
        callback = callback,
    })
end

--- @param on_attach fun(client: vim.lsp.Client|nil, bufnr: integer)
function M.lsp_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*",
        callback = function(args)
            if not (args.data and args.data.client_id) then return end
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, bufnr)
        end,
    })
end

--- @param cmd string
--- @param callback fun()
--- @param opts table optional
function M.user_cmd(cmd, callback, opts)
    vim.api.nvim_create_user_command(cmd, function() pcall(callback) end, opts)
end

return M
