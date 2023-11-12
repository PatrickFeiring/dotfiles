vim.o.hidden = true
vim.o.updatetime = 300

vim.opt.mouse = nil

vim.o.wrap = false

vim.o.wildmenu = true
vim.o.wildignorecase = true
vim.o.wildignore = vim.o.wildignore .. "*.o"

vim.o.shortmess = vim.o.shortmess .. "I"

vim.o.statusline = ""
vim.o.statusline = vim.o.statusline .. "%f" -- Path
vim.o.statusline = vim.o.statusline .. "%h%m%r%w" -- Status
vim.o.statusline = vim.o.statusline .. "%=" -- Shift right after here
vim.o.statusline = vim.o.statusline .. "%y" -- File type

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftround = true

vim.o.termguicolors = true
vim.o.t_8f = "<Esc>[38;2;%lu;%lu;%lum"
vim.o.t_8b = "<Esc>[48;2;%lu;%lu;%lum"

vim.o.number = true
vim.o.relativenumber = true
vim.keymap.set("n", "<C-n>", ":set rnu!<CR>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "Y", "y$")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.o.foldmethod = "indent"
vim.o.foldlevelstart = 20

vim.o.lazyredraw = true
vim.keymap.set("n", "Q", "@q")
vim.keymap.set("v", "Q", ":'<,'>normal! @q <CR>")

vim.o.spelllang = "en_us"
