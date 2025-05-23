vim.g.mapleader = ","
vim.g.python3_host_prog = "~/.virtualenvs/neovim/bin/python"

require("user.globals")
require("user.general")

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup("user.plugins", {
    install = {
        colorscheme = { "tokyonight" },
    },
    change_detection = {
        notify = false,
    },
})

prequire("user.local")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argv(0) == "" then
            vim.cmd("Files")
        end
    end,
})
