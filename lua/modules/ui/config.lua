local config = {}
local uv = vim.loop

local keymap = require("core.keymap")
local nmap = keymap.nmap
local silent, noremap, nowait = keymap.silent, keymap.noremap, keymap.nowait
local opts = keymap.new_opts
local cmd = keymap.cmd

function config.horizon()
  require("horizon").setup({})
  vim.cmd.colorscheme("horizon")
end

function config.fluoromachine()
  require("fluoromachine").setup({
    glow = true,
    theme = "retrowave",
  })
  vim.cmd.colorscheme("fluoromachine")
end

function config.synthwave84()
  require("synthwave84").setup({})
  vim.cmd.colorscheme("synthwave84")
end

function config.tokyodark()
  require("tokyodark").setup({})
  vim.cmd.colorscheme("tokyodark")
end

function config.onedark()
  require("onedark").setup({
    style = "deep",
    highlights = {
      ["@string"] = { fg = "#eed49f" },
    },
  })
  require("onedark").load()
end

function config.tokyonight()
  require("tokyonight").setup({
    style = "moon",
    transparent = false,
    terminal_colors = true,
    styles = {
      functions = { italic = true },
      sidebars = "dark",
      floats = "dark",
    },
    sidebars = { "terminal", "qf", "help" },
    on_highlights = function(h, _)
      h.String = { fg = "#eed49f" }
      h["@keyword"] = { fg = "#ff757f" }
      h["@keyword.function"] = { fg = "#ff757f" }
      h["@variable.member"] = { fg = "#c8d3f5" }
      -- h["@property"] = { fg = "#41a6b5" }
      -- h["@property"] = { fg = "#ffc777" }
      -- h.String = { fg = "#eed49f" }
      -- h.Identifier["fg"] = "#ee99a0"
    end,
    hide_inactive_statusline = false,
    dim_inactive = false,
    lualine_bold = false,
  })

  vim.cmd.colorscheme("tokyonight")
end

function config.catppuccin()
  require("catppuccin").setup({
    flavour = "macchiato",
    term_colors = true,
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    integrations = {
      noice = true,
      lsp_saga = true,
      cmp = true,
      dap = {
        enabled = true,
        enable_ui = true, -- enable nvim-dap-ui
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      telescope = {
        enabled = true,
        -- style = "nvchad"
      },
      lsp_trouble = true,
      illuminate = true,
      treesitter = true,
      aerial = true,
      alpha = true,
      beacon = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
      mason = true,
    },
  })
  vim.cmd.colorscheme("catppuccin")
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

function config.nvim_tree()
  local api = require("nvim-tree.api")
  local float_preview = require("float-preview")
  local function close_wrap_cmd(inner_cmd)
    return cmd("lua require('float-preview').close_wrap(" .. inner_cmd .. ")()")
  end
  local function api_cmd(inner_cmd)
    return close_wrap_cmd("require('nvim-tree.api')." .. inner_cmd)
  end
  local function on_attach(bufnr)
    float_preview.attach_nvimtree(bufnr)
    api.config.mappings.default_on_attach(bufnr)
    local nopts = opts(noremap, silent, nowait)
    nopts.buffer = bufnr
    nmap({
      { "l", api_cmd("node.open.tab"), nopts },
      { "h", api_cmd("node.navigate.parent_close"), nopts },
      { "N", api_cmd("fs.create"), nopts },
      { "v", api_cmd("node.open.vertical"), nopts },
      { "s", api_cmd("node.open.horizontal"), nopts },
      { ".", api_cmd("tree.toggle_gitignore_filter"), nopts },
      { "q", api_cmd("tree.close"), nopts },
      { "o", api_cmd("node.open.edit"), nopts },
      { "r", api_cmd("fs.rename"), nopts },
      { "d", api_cmd("fs.remove"), nopts },
    })
  end
  require("nvim-tree").setup({
    disable_netrw = true,
    hijack_cursor = true,
    on_attach = on_attach,
    view = {
      float = {
        enable = true,
      },
    },
    diagnostics = {
      enable = true,
    },
    actions = {
      open_file = {
        window_picker = {
          chars = "1234567890",
        },
      },
    },
  })
end

function config.alpha()
  require("alpha.term")
  local dashboard = require("alpha.themes.dashboard")
  if vim.fn.executable("chafa") > 0 then
    dashboard.section.header.type = "terminal"
    dashboard.section.header.command = string.format(
      "chafa -s 75x75 -f symbols -c full --fg-only --symbols braille --clear %s/.config/nvim/static/AllNightRadio.jpg",
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
  -- auto session on alpha loaded
  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
      local handle
      handle, _ = uv.spawn(
        "sleep",
        { args = { "1s" }, stdio = nil },
        vim.schedule_wrap(function(_)
          handle:close()
          require("persistence").load()
        end)
      )
    end,
  })

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
  require("lualine").setup({
    sections = {
      lualine_x = { "encoding", "fileformat", "filetype" },
    },
    options = {
      icons_enabled = true,
      theme = "auto",
      -- theme = "fluoromachine",
      -- theme = "synthwave84",
      -- theme = "bluloco",
      -- theme = "tokyonight",
      -- theme = "horizon",
      -- theme = "catppuccin",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
  })
end

local rainbow_highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

function config.rainbow_delimiters()
  local rainbow_delimiters = require("rainbow-delimiters")

  vim.g.rainbow_delimiters = {
    strategy = {
      [""] = rainbow_delimiters.strategy["global"],
      vim = rainbow_delimiters.strategy["local"],
    },
    query = {
      [""] = "rainbow-delimiters",
      lua = "rainbow-blocks",
    },
    highlight = rainbow_highlight,
  }
end

function config.indent_blanklinke()
  vim.opt.list = true
  vim.opt.listchars:append("space:⋅")
  local highlight = {
    "IndentRainbowRed",
    "IndentRainbowYellow",
    "IndentRainbowBlue",
    "IndentRainbowCyan",
  }
  local hooks = require("ibl.hooks")
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    vim.api.nvim_set_hl(0, "IndentRainbowRed", { bg = "#373043" })
    vim.api.nvim_set_hl(0, "IndentRainbowYellow", { bg = "#373744" })
    vim.api.nvim_set_hl(0, "IndentRainbowBlue", { bg = "#2e384a" })
    vim.api.nvim_set_hl(0, "IndentRainbowCyan", { bg = "#2e3848" })
  end)
  require("ibl").setup({
    indent = {
      highlight = rainbow_highlight,
      char = "",
      tab_char = "",
    },
    whitespace = {
      highlight = highlight,
      remove_blankline_trail = true,
    },
    scope = {
      enabled = true,
      highlight = rainbow_highlight,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
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
      buftypes = { "terminal", "nofile" },
    },
  })
  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
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

function config.winsep()
  require("colorful-winsep").setup({
    create_event = function()
      local win_n = require("colorful-winsep.utils").calculate_number_windows()
      if win_n == 2 then
        local win_id = vim.fn.win_getid(vim.fn.winnr("h"))
        local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), "filetype")
        if filetype == "NvimTree" then
          require("colorful-winsep").NvimSeparatorDel()
        end
      end
    end,
  })
end

function config.usage()
  local function h(name)
    return vim.api.nvim_get_hl(0, { name = name })
  end

  -- hl-groups can have any name
  vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
  vim.api.nvim_set_hl(
    0,
    "SymbolUsageContent",
    { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
  )
  vim.api.nvim_set_hl(
    0,
    "SymbolUsageRef",
    { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true }
  )
  vim.api.nvim_set_hl(
    0,
    "SymbolUsageDef",
    { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true }
  )
  vim.api.nvim_set_hl(
    0,
    "SymbolUsageImpl",
    { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true }
  )

  local function text_format(symbol)
    local res = {}

    local round_start = { "", "SymbolUsageRounding" }
    local round_end = { "", "SymbolUsageRounding" }

    if symbol.references then
      local usage = symbol.references <= 1 and "usage" or "usages"
      local num = symbol.references == 0 and "no" or symbol.references
      table.insert(res, round_start)
      table.insert(res, { "󰌹 ", "SymbolUsageRef" })
      table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    if symbol.definition then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, round_start)
      table.insert(res, { "󰳽 ", "SymbolUsageDef" })
      table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    if symbol.implementation then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, round_start)
      table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
      table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    return res
  end

  require("symbol-usage").setup({
    text_format = text_format,
  })
end

return config
