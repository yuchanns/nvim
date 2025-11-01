local Util = require "lazy.core.util"

local M = {}

---@param name string
function M.load_mod(name)
    Util.lsmod(name, function(modname, _) require(modname) end)
end

---@param names string[]
---@return fun()
function M.callback_load_mods(names)
    return function()
        for _, name in ipairs(names) do
            M.load_mod(name)
        end
    end
end

return M
