vim.g.mapleader = " "

--- Generic Vim Stuff ---
--All mighty yank
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

--Diagnostic Window
vim.keymap.set('n', "<leader>e", "<cmd> lua vim.diagnostic.open_float() <CR>")


--- Telescope ---
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope git find files' })
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)


--- Dap ---
local dap = require("dap")
local dapui = require("dapui")

--Stepping through code
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)

--Breakpoints
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

-- REPL(Read-Evaluate-Print-Loop) ie write code and auto update the running
-- program :D vvvvv
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end,
{ desc = "DAP REPL open" })

vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function() require('dap.ui.widgets').preview() end)
vim.keymap.set('n', '<Leader>df', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.frames) end)
vim.keymap.set('n', '<Leader>ds', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.scopes) end)

--DapUI--
--close
vim.keymap.set('n', '<Leader>do', dapui.open, { desc = 'DapUI open'} )
vim.keymap.set('n', '<Leader>dc', dapui.close, { desc = 'DapUI close'} )
vim.keymap.set('n', '<Leader>dt', dapui.toggle, { desc = 'DapUI toggle'} )

--nvim-tree
vim.keymap.set('n', '<Leader>e', ":NvimTreeToggle<CR>", { desc = "Nvim-Tree Explorer" })
