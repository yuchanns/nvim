## Hanchin Hsieh's NeoVIM Configuration

![nvim](https://github.com/yuchanns/nvim/assets/25029451/0453801d-8f3a-4a37-bcf1-20398b73eb52)

Built on top of [lazy.nvim](https://github.com/folke/lazy.nvim).

Compatible for Linux, MacOS and Windows.

### Dependencies

To ensure proper functionality of NeoVIM, additional dependencies are required.

- Zig
  - For parsers installation of `nvim-treesitter`
- Python3
  - For `nvim-cmp` and `ultisnips`
  - pyenv is recommendation
  - Extra modules are required: `python -m pip install typing_extensions pynvim`
  - If you encounter issues, run `: checkhealth provider.python` to check the problem
- NodeJS (optional)
  - For `MasonInstall ts_ls`
  - fnm is recommendation
- Rust (optional)
  - For `MasonInstall rust-analyzer`
- yazi
  - For file browser
- lazygit
  - For GUI git client
- ripgrep (optional)
  - For list todo comments
- Go (optional)
  - For `Masoninstall gopls`
  - `go install github.com/mgechev/revive@latest` for formatting
  - `go install golang.org/x/tools/cmd/goimports@latest` for importing
  - `go install github.com/josharian/impl@latest` for generating method stubs for implementing an interface.
- chafa (optional)
  - For dashboard

