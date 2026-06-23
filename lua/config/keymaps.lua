vim.g.mapleader = " "

-- Generic Vim Stuff ---
-- All mighty yank
vim.keymap.set('n', "<leader>y", "\"+y")
vim.keymap.set('v', "<leader>y", "\"+y")
vim.keymap.set('n', "<leader>Y", "\"+Y")

-- Diagnostic Window
vim.keymap.set('n', 
"<leader>d", 
"<cmd> lua vim.diagnostic.open_float() <CR>", 
{ desc = "Opens diagnostic floating window" })

-- Alternate file rebind
vim.keymap.set('n', "<leader><leader>", "<C-^>", { desc = "vim 'Alternate file' rebind" })
