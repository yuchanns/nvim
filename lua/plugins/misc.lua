local keymap = require("utils.keymap")
local nmap = keymap.nmap
local cmd = keymap.cmd
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local uv = vim.loop
local system = require("utils.system")
local autocmd = require("utils.autocmd")

autocmd.user_pattern("LazyDone", function()
  require("telescope").load_extension("fzy_native")
  require("telescope").load_extension("file_browser")
end)

autocmd.user_pattern("AlphaReady", function()
  local handle
  local on_exit = vim.schedule_wrap(function(_)
    handle:close()
    require("persistence").load()
  end)
  if system.is_windows() then
    handle, _ = uv.spawn(
      "powershell",
      { args = { "-Command", "Start-Sleep -Seconds 1s" }, stdio = nil },
      on_exit
    )
  else
    handle, _ = uv.spawn(
      "sleep",
      { args = { "1s" }, stdio = nil },
      on_exit
    )
  end
end)

nmap({
  {
    "<Leader>fa",
    cmd("Telescope live_grep"),
    opts(noremap, silent),
  },
  { "<Leader>v", cmd("vsplit"), opts(noremap, silent) },
  { "<Leader>s", cmd("split"),  opts(noremap, silent) },
  {
    "s",
    function()
      require("flash").jump()
    end,
    opts(noremap, silent),
  },
  { "<Leader>c", cmd([[lua require("ccr").copy_rel_path_and_line()]]), opts(noremap, silent) },
  {
    "<Leader>xx",
    cmd("Trouble diagnostics toggle"),
    opts(noremap, silent),
  },
  {
    "<Leader>xq",
    cmd("Trouble quickfix toggle"),
    opts(noremap, silent),
  },
  {
    "<Leader>xt",
    cmd("Trouble todo toggle"),
    opts(noremap, silent),
  },
  { "=",         cmd("exe 'resize +1.5'"),                             opts(noremap, silent) },
  { "-",         cmd("exe 'resize -1.5'"),                             opts(noremap, silent) },
  { "+",         cmd("exe 'vertical resize +1.5'"),                    opts(noremap, silent) },
  { "_",         cmd("exe 'vertical resize -1.5'"),                    opts(noremap, silent) },
})

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = {
      defaults = {
        layout_config = {
          horizontal = { prompt_position = "top", results_width = 0.6 },
          vertical = { mirror = false },
        },
        sorting_strategy = "ascending",
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        file_ignore_patterns = { "node_modules" },
        path_display = { "smart" },
      },
      extensions = {
        fzy_native = {
          override_generic_sorter = true,
          override_file_sorter = true,
        },
        file_browser = {
          hidden = true,
          respect_gitignore = true,
        },
      },
    },
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
  },
  {
    "Pocco81/auto-save.nvim",
    opts = {
      enabled = true,
      execution_message = { message = "" },
    },
    branch = "dev",
  },
  { "windwp/nvim-autopairs", opts = {} },
  {
    "karb94/neoscroll.nvim",
    opts = {
      mappings = {
        "<C-u>",
        "<C-d>",
      },
    },
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "folke/flash.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "folke/persistence.nvim",
    opts = {},
    event = "BufReadPre",
  },
  { "folke/trouble.nvim",    opts = {} },
  {
    "folke/todo-comments.nvim",
    opts = {
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--glob=!vendor",
          "--glob=!node_modules",
        },
      },
    }
  },
  { "yuchanns/ccr.nvim" },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("alpha.term")
      local dashboard = require("alpha.themes.dashboard")
      if system.is_executable("chafa") then
        dashboard.section.header.type = "terminal"
        local image = vim.fn.stdpath("config") .. "/static/AllNightRadio.jpg"
        dashboard.section.header.command = string.format(
          "chafa -s 75x75 -f symbols -c full --fg-only --symbols braille --clear %s",
          image
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
    end,
  },
  { "danilamihailov/beacon.nvim" },
}
