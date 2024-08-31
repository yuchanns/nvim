local keymap = require("core.keymap")
local nmap = keymap.nmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

nmap({
  {
    "bb",
    cmd("BufferLinePick"),
    opts(noremap, silent),
  },
  {
    "bc",
    cmd("BufferLinePickClose"),
    opts(noremap, silent),
  },
  {
    "bo",
    cmd("BufferLineCloseOthers"),
    opts(noremap, silent),
  },
  {
    "bd",
    cmd("BufferLineSortByDirectory"),
    opts(noremap, silent),
  },
  {
    "be",
    cmd("BufferLineSortByExtension"),
    opts(noremap, silent),
  },
  {
    "b[",
    cmd("BufferLineCyclePrev"),
    opts(noremap, silent),
  },
  {
    "b]",
    cmd("BufferLineCycleNext"),
    opts(noremap, silent),
  },
  { "<C-h>", function() require('swap-buffers').swap_buffers('h') end, opts(noremap, silent) },
  { "<C-j>", function() require('swap-buffers').swap_buffers('j') end, opts(noremap, silent) },
  { "<C-k>", function() require('swap-buffers').swap_buffers('k') end, opts(noremap, silent) },
  { "<C-l>", function() require('swap-buffers').swap_buffers('l') end, opts(noremap, silent) },
})


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
            local sym = e == "error" and " " or (e == "warning" and " " or "")
            s = s .. n .. sym
          end
          return s
        end,
        custom_areas = {
          right = function()
            local result = {}
            local error = vim.diagnostic.get(0, [[Error]])
            local warning = vim.diagnostic.get(0, [[Warning]])
            local info = vim.diagnostic.get(0, [[Information]])
            local hint = vim.diagnostic.get(0, [[Hint]])

            if error ~= 0 then
              table.insert(result, { text = "  " .. error, guifg = "#EC5241" })
            end

            if warning ~= 0 then
              table.insert(result, { text = "  " .. warning, guifg = "#EFB839" })
            end

            if hint ~= 0 then
              table.insert(result, { text = "  " .. hint, guifg = "#A3BA5E" })
            end

            if info ~= 0 then
              table.insert(result, { text = "  " .. info, guifg = "#7EA9A7" })
            end
            return result
          end,
        },
        show_close_icon = false,
        show_buffer_close_icons = false,
        offsets = {},
      },
    },
    event = "BufRead",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "caenrique/swap-buffers.nvim", opts = {},
  }
}
