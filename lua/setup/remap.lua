vim.g.mapleader = " "

--- Generic Vim Stuff ---
--All mighty yank
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

--Diagnostic Window
vim.keymap.set('n', "<leader>d", "<cmd> lua vim.diagnostic.open_float() <CR>")

vim.keymap.set('n', "<Leader><Leader>", "<C-^>", { desc = "vim 'Alternate File' binding" })

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

-- Save, and compile C++ files
--[[
-- My messed up version
vim.keymap.set('n', '<Leader>C', function()
  if vim.bo.filetype == 'cpp' then
    vim.cmd("write")
    local filepath = vim.fn.shellescape(vim.fn.expand('%:p'))
    local binary = vim.fn.shellescape(vim.fn.expand('%:p:r'))
    local standard = "-std=c++20 "
    local warningFlags = " -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion "
    local warningAsError = "-Werror "

    vim.cmd("split | terminal g++ -g " .. standard .. filepath .. " -o " .. binary .. warningFlags .. warningAsError .. " -O0")
  else
    print(vim.fn.expand('%:h'), " is not a CPP file")
  end
end)

--Gippity suggestions
vim.cmd("split")
local buf = vim.api.nvim_get_current_buf()

vim.fn.termopen({
  "g++",
  "-g",
  "-std=c++20",
  filepath,
  "-o",
  binary,
  "-Wall",
  "-Weffc++",
  "-Wextra",
  "-Wconversion",
  "-Wsign-conversion",
  "-Werror",
  "-O0",
}, {
  on_exit = function(_, code)
    vim.schedule(function()
      if code == 0 then
        vim.cmd("bd! " .. buf) -- close terminal buffer
        vim.notify("Build succeeded", vim.log.levels.INFO)
      else
        vim.notify("Build failed (see terminal)", vim.log.levels.ERROR)
      end
    end)
  end,
})

--My Maybe better version after looking at the docs
local filepath = vim.fn.expand('%:p')
local binary = vim.fn.expand('%:p:r')

vim.system({
  'g++', 
  '-g', 
  '-std=c++20', 
  filepath, 
  '-o', 
  binary, 
  '-Wall', 
  '-Weffc++', 
  '-Wextra',
  '-Wsign-conversion',
  '-Werror',
  '-O0',
}, { text = true }, function(result)
  vim.schedule(function()
    if result.code == 0 then
      vim.notify("Build succeeded :)", vim.log.levels.INFO)
      return
    end
      vim.notify(result.stderr or "Build failed :(", vim.log.levels.ERROR)
    end
  end)
end)
]]
--revision revision
local function compile_cpp()
  vim.cmd("write")

  local filepath = vim.fn.expand('%:p')
  local binary = vim.fn.expand('%:p:r')

  vim.system({
    'g++',
    '-g',
    '-std=c++20',
    filepath,
    '-o',
    binary,
    '-Wall',
    '-Weffc++',
    '-Wextra',
    '-Wsign-conversion',
    '-Werror',
    '-O0',
  }, { text = true }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        vim.notify("Build succeeded", vim.log.levels.INFO)
        return
      end

      -- Failure path: open a panel
      local buf = vim.api.nvim_create_buf(false, true)

      local stderr = result.stderr or "Unknown error"
      local lines = vim.split(stderr, "\n", { plain = true })

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

      vim.cmd("botright split")
      vim.api.nvim_win_set_buf(0, buf)

      vim.bo[buf].filetype = "log"
      vim.bo[buf].modifiable = false

      vim.notify("Build failed", vim.log.levels.ERROR)
    end)
  end)
end

vim.keymap.set('n', '<Leader>C', compile_cpp)
