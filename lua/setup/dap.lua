local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup()

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    --Should make this a different variable 
    command = vim.fn.expand("~/.local/share/nvim/mason/bin/codelldb"),
    args = { "--port", "${port}" },
  }
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",

    program = function()
      return vim.fn.input(
        'Path to exectuable: ',
        vim.fn.getcwd() .. '/',
        'file'
      )
    end,

    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.configurations.c = dap.configurations.cpp
