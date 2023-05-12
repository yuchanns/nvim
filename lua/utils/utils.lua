local Utils = {}

function Utils.auto_cmd(event, cmd, callback)
  local group = vim.api.nvim_create_augroup(event .. "_" .. cmd, { clear = true })
  vim.api.nvim_create_autocmd(event, {
    group = group,
    callback = callback,
  })
end

return Utils
