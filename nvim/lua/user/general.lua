vim.g.mapleader = ","

-- Be explicit about what goes into system clipboard, instead of something
-- like `unnamedplus`
vim.opt.clipboard = ""

vim.o.hidden = true
vim.o.updatetime = 300

vim.g.python3_host_prog = "~/.virtualenvs/neovim/bin/python"

vim.opt.mouse = nil

vim.o.wrap = false

vim.o.wildmenu = true
vim.o.wildignorecase = true
vim.o.wildignore = vim.o.wildignore .. "*.o"

vim.o.shortmess = vim.o.shortmess .. "I"

-- stylua: ignore start
vim.o.statusline = ""
vim.o.statusline = vim.o.statusline .. "%f"       -- Path
vim.o.statusline = vim.o.statusline .. "%h%m%r%w" -- Status
vim.o.statusline = vim.o.statusline .. "%="       -- Shift right after here
vim.o.statusline = vim.o.statusline .. "%y"       -- File type
-- stylua: ignore end

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftround = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.hlsearch = true
vim.o.incsearch = true

vim.keymap.set("n", "<CR>", ":noh<CR><CR>")

-- vim.o.termguicolors = true
-- vim.o.t_8f = "<Esc>[38;2;%lu;%lu;%lum"
-- vim.o.t_8b = "<Esc>[48;2;%lu;%lu;%lum"

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
vim.o.spell = true
vim.keymap.set("n", "<C-F>", function()
    if vim.fn.spellbadword()[1] ~= "" then
        vim.api.nvim_feedkeys("1z=", "n", false)
    else
        vim.api.nvim_feedkeys("]s1z=", "n", false)
    end
end, { desc = "Fix spelling of next misspelled word" })

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

-- Replace text inside an area defined with a textobject
_G.replace_textobject = function(type)
    if type == nil then
        vim.o.operatorfunc = "v:lua.replace_textobject"
        return "g@"
    end

    local first = vim.api.nvim_buf_get_mark(0, "[")[1]
    local last = vim.api.nvim_buf_get_mark(0, "]")[1]

    vim.cmd("call feedkeys(':" .. first .. "," .. last .. "s/')")
end

local replace_current_line = function()
    return _G.replace_textobject() .. "_"
end

local opts = { noremap = true, expr = true }

vim.keymap.set("n", "<leader>r", _G.replace_textobject, opts)
vim.keymap.set("n", "<leader>rr", replace_current_line, opts)
vim.keymap.set("x", "<leader>r", ":s/")

vim.cmd([[
    function! s:execute_line() abort
        if &ft == 'lua'
            call execute(printf(':lua %s', getline('.')))
        elseif &ft == 'vim'
            exe getline('.')
        endif
    endfunction

    function! s:save_and_execute_file() abort
        if &ft == 'lua'
            :silent! write
            :luafile %
        elseif &ft == 'vim'
            :silent! write
            :source %
        endif
    endfunction

    nnoremap <leader>x :call <SID>execute_line()<CR>
    vnoremap <leader>x :<C-w>exe join(get("'<", "'>"), '<Bar>')<CR>
    nnoremap <leader><leader>x :call <SID>save_and_execute_file()<CR>
]])

-- Neovim treats .env files as sh, we also do the same for .env.example etc.
vim.filetype.add({
    pattern = {
        [".*%.env%..*"] = "sh",
    },
})

vim.diagnostic.config({
    severity_sort = true,
})

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- We don't want a sign column that causes layout shifts depending on whether
-- there are diagnostics or not
vim.o.signcolumn = "yes"
