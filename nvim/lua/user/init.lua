require("user.globals")

vim.g.mapleader = ","
vim.g.python3_host_prog = "~/.virtualenvs/neovim/bin/python"

require("user.general")

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("user.plugins"), {
    install = {
        colorscheme = { "nord" },
    },
})

require("user.completion")
require("user.debuggers")
require("user.finders")
require("user.lsps")
require("user.snippets")
require("user.treesitter")

prequire("user.local")
