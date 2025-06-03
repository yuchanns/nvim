local executable = vim.fn.executable

local M = {}

--- @return boolean
function M.is_windows() return vim.uv.os_uname().sysname == "Windows_NT" end

--- @return boolean
function M.is_linux() return vim.uv.os_uname().sysname == "Linux" end

--- @return boolean
function M.is_mac() return vim.uv.os_uname().sysname == "Darwin" end

--- @param bin string
--- @return boolean
function M.is_executable(bin) return executable(bin) > 0 end

return M
