local config = {}

function config.tokyonight()
  vim.g.tokyonight_transparent = false
  vim.g.tokyonight_italic_functions = true
  vim.g.tokyonight_sidebars = { "terminal", "packer", "qf" }

  vim.cmd([[colorscheme tokyonight]])
end

function config.vfilter()
  require("vfiler/config").setup({
    options = {
      auto_cd = true,
      auto_resize = true,
      keep = true,
      layout = "floating",
      columns = "indent,devicons,name,mode,size,time",
      listed = false,
      blend = 30,
    },
  })
end

function config.alpha()
  math.randomseed(os.time())
  -- local colors = { "white", "violet", "lightyellow", "#7ba2f7" }
  local colors = { "#7ba2f7", "#9b348e", "#db627c", "#fda17d", "#86bbd8", "#33648a" }
  local function random_colors(color_lst)
    return color_lst[math.random(1, #color_lst)]
  end
  vim.cmd(string.format("highlight dashboard guifg=%s guibg=bg", random_colors(colors)))
  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.header.val = require("modules.ui.header")
  dashboard.section.header.opts.hl = "dashboard"

  dashboard.section.buttons.val = {
    dashboard.button("cn", "  New File       ", ":enew<CR>", nil),
    dashboard.button("ff", "  Browse File    ", ":lua require('vfiler').start()<CR>", nil),
    dashboard.button(
      "fa",
      "  Find Word      ",
      ":lua require('telescope.builtin').live_grep()<CR>",
      nil
    ),
    dashboard.button(
      "fh",
      "  Find History   ",
      ":lua require('telescope.builtin').oldfiles()<CR>",
      nil
    ),
  }

  require("alpha").setup(dashboard.opts)
end

function config.nvim_bufferline()
  require("bufferline").setup({
    options = {
      separator_style = "slant",
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
      offsets = {},
    },
  })
end

return config
