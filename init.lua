local venv_python = vim.fn.stdpath "config" .. "/.venv/bin/python"

if vim.fn.executable(venv_python) == 1 then
    vim.g.python3_host_prog = venv_python
end

require "core.lazy"
