vim.o.splitbelow = true
vim.o.splitright = true

-- When splitting horizontally, we make sure we get sufficient space for the
-- new window
vim.o.winheight = 30
vim.o.winminheight = 5

vim.keymap.set({ "n", "t" }, "<C-J>", "<C-W><C-J>")
vim.keymap.set({ "n", "t" }, "<C-K>", "<C-W><C-K>")
vim.keymap.set({ "n", "t" }, "<C-L>", "<C-W><C-L>")
vim.keymap.set({ "n", "t" }, "<C-H>", "<C-W><C-H>")
