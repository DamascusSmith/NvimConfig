-- after/plugin/oil.lua
local ok, oil = pcall(require, "oil")
if not ok then return end

-- store the root directory you started Neovim in
local root_dir = vim.fn.getcwd()

-- setup Oil first
oil.setup({
    default_file_explorer = true,
    columns = { "icon", "size" },
})

-- <Leader>pv: open parent directory but don’t go above root_dir
vim.keymap.set("n", "<leader>pv", function()
    local current = vim.fn.expand("%:p")
    if current == "" then
        current = vim.fn.getcwd()
    else
        current = vim.fn.expand("%:p:h")
    end

    local parent = vim.fn.fnamemodify(current, ":h")

    -- don’t go above root_dir
    if vim.fn.stridx(parent, root_dir) == 0 then
        require("oil").open(parent)
    else
        require("oil").open(root_dir)
    end
end, { desc = "Open parent directory (capped at root)" })

