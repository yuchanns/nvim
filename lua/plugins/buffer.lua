local keymap = require "utils.keymap"
local nmap = keymap.nmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

nmap {
    {
        "bb",
        cmd "BufferLinePick",
        opts(noremap, silent),
    },
    {
        "bc",
        cmd "BufferLinePickClose",
        opts(noremap, silent),
    },
    {
        "bo",
        cmd "BufferLineCloseOthers",
        opts(noremap, silent),
    },
    {
        "bd",
        cmd "BufferLineSortByDirectory",
        opts(noremap, silent),
    },
    {
        "be",
        cmd "BufferLineSortByExtension",
        opts(noremap, silent),
    },
    {
        "b[",
        cmd "BufferLineCyclePrev",
        opts(noremap, silent),
    },
    {
        "b]",
        cmd "BufferLineCycleNext",
        opts(noremap, silent),
    },
    { "<C-h>", function() require "swap-buffers".swap_buffers "h" end,   opts(noremap, silent) },
    { "<C-j>", function() require "swap-buffers".swap_buffers "j" end,   opts(noremap, silent) },
    { "<C-k>", function() require "swap-buffers".swap_buffers "k" end,   opts(noremap, silent) },
    { "<C-l>", function() require "swap-buffers".swap_buffers "l" end,   opts(noremap, silent) },
}

return {
    { "famiu/bufdelete.nvim" },
    {
        "akinsho/nvim-bufferline.lua",
        opts = {
            options = {
                separator_style = "thin",
                indicator = { style = "underline" },
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(_, _, diagnostics_dict, _)
                    local s = " "
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and " " or (e == "warning" and " " or (e == "hint" and "" or ""))
                        s = s .. n .. sym
                    end
                    return s
                end,
                custom_areas = {
                    right = function()
                        local result = {}
                        local seve = vim.diagnostic.severity
                        local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
                        local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
                        local info = #vim.diagnostic.get(0, { severity = seve.INFO })
                        local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

                        if error ~= 0 then table.insert(result, { text = "  " .. error, link = "DiagnosticError" }) end

                        if warning ~= 0 then table.insert(result, { text = "  " .. warning, link = "DiagnosticWarn" }) end

                        if hint ~= 0 then table.insert(result, { text = "  " .. hint, link = "DiagnosticHint" }) end

                        if info ~= 0 then table.insert(result, { text = "  " .. info, link = "DiagnosticInfo" }) end
                        return result
                    end,
                },
                show_close_icon = false,
                show_buffer_close_icons = false,
                show_buffer_icons = true,
                offsets = {},
            },
        },
        event = "BufRead",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "caenrique/swap-buffers.nvim",
        opts = {},
    },
}
