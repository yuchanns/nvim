local M = {}

function M.user_pattern(pattern, callback)
  vim.api.nvim_create_autocmd("User", {
    pattern = pattern,
    callback = callback,
  })
end

function M.autocmd(event, cmd, callback)
  local group = vim.api.nvim_create_augroup(event .. "_" .. cmd, { clear = true })
  vim.api.nvim_create_autocmd(event, {
    group = group,
    callback = callback,
  })
end

function M.on_lsp_attach(attach, on_attach)
  M.autocmd("LspAttach", attach, function(args)
    if not (args.data and args.data.client_id) then
      return
    end
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    on_attach(client, bufnr)
  end)
end

return M
