local utils = require("user.utils")

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.hlsearch = true
vim.o.incsearch = true

vim.keymap.set("n", "<CR>", ":noh<CR><CR>")

vim.keymap.set("n", "<C-W><C-[>", function()
    utils.cycle_file_group("backward")
end)
vim.keymap.set("n", "<C-W><C-]>", function()
    utils.cycle_file_group()
end)
