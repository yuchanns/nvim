local keymap = require("utils.keymap")
local nmap = keymap.nmap
local cmd = keymap.cmd
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local autocmd = require("utils.autocmd")

autocmd.user_pattern("LazyDone", function()
  require("telescope").load_extension("lazygit")
end)

nmap({
  "<Leader>l",
  cmd("LazyGit"),
  opts(noremap, silent),
})

return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      linehl = false,
      numhl = true,

      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "ﬠ" },
        topdelete = { text = "ﬢ" },
      },
    }
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  }
}
