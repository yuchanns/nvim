local config = {}

function config.tokyonight()
  require("tokyonight").setup({
    transparent = false,
    styles = { functions = { italic = true } },
    sidebars = { "terminal", "qf" },
  })

  vim.cmd.colorscheme("tokyonight")
end

function config.vfilter()
  require("vfiler/patches/noice").setup()
  require("vfiler/config").setup({
    options = {
      auto_cd = true,
      auto_resize = true,
      keep = true,
      layout = "floating",
      columns = "indent,devicons,name,mode,size,time",
      listed = false,
      blend = 30,
      session = "share",
    },
  })
end

function config.alpha()
  require("alpha.term")
  local dashboard = require("alpha.themes.dashboard")
  if vim.fn.executable("chafa") > 0 then
    dashboard.section.header.type = "terminal"
    dashboard.section.header.command = string.format(
      "chafa -s 75x75 -c full --fg-only --symbols braille --clear %s/.config/nvim/static/Avatar.jpeg",
      os.getenv("HOME")
    )
    dashboard.section.header.height = 33
    dashboard.section.header.width = 75
    dashboard.section.header.opts = {
      position = "center",
      redraw = true,
      window_config = { height = 30 },
    }
  else
    math.randomseed(os.time())
    local colors = { "#7ba2f7", "#9b348e", "#db627c", "#fda17d", "#86bbd8", "#33648a" }
    local function random_colors(color_lst)
      return color_lst[math.random(1, #color_lst)]
    end
    vim.cmd(string.format("highlight dashboard guifg=%s guibg=bg", random_colors(colors)))
    dashboard.section.header.val = require("modules.ui.header")
    dashboard.section.header.opts.hl = "dashboard"
  end

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
  vim.opt.termguicolors = true
  require("bufferline").setup({
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
  })
end

function config.lualine()
  local CodeGPTModule = require("codegpt")
  require("lualine").setup({
    sections = {
      lualine_x = { CodeGPTModule.get_status, "encoding", "fileformat", "filetype" },
    },
    options = {
      icons_enabled = true,
      theme = "tokyonight",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
  })
end

function config.indent_blanklinke()
  vim.opt.list = true
  vim.opt.listchars:append("space:⋅")
  require("indent_blankline").setup({
    space_char_blankline = " ",
    show_current_context = true,
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
      "startify",
      "dashboard",
      "dotooagenda",
      "log",
      "fugitive",
      "gitcommit",
      "packer",
      "vimwiki",
      "markdown",
      "json",
      "txt",
      "vista",
      "help",
      "todoist",
      "NvimTree",
      "peekaboo",
      "git",
      "TelescopePrompt",
      "undotree",
      "flutterToolsOutline",
      "", -- for all buffers without a file type
    },
    use_treesitter = true,
    char_list = { "|", "¦", "┆", "┊" },
    show_first_indent_level = true,
    show_trailing_blankline_indent = false,
  })
end

function config.dapui()
  local dap, dapui = require("dap"), require("dapui")

  dapui.setup({
    layouts = {
      {
        elements = { "scopes", "breakpoints", "stacks", "watches" },
        size = 40,
        position = "right",
      },
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

function config.notify()
  require("noice").setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = { enable = false },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  })
end

function config.colors()
  require("lsp-colors").setup()
end

return config
