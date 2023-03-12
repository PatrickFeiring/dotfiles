vim.keymap.set("n", "<leader>d", ":Files<CR>")
vim.keymap.set("n", "<leader>e", ":Buffers<CR>")
vim.keymap.set("n", "<leader>s", ":Rg<Space>")
vim.keymap.set("n", "<leader>t", ":BTags<CR>")
vim.keymap.set("n", "<leader>T", ":Tags<CR>")

-- Visual mode variants that paste the selected word
vim.keymap.set("v", "<leader>d", 'y:Files<Space><C-R>"<CR>')
vim.keymap.set("v", "<leader>e", 'y:Buffers<Space><C-R>"<CR>')
vim.keymap.set("v", "<leader>s", 'y:Rg<Space><C-R>"<CR>')
vim.keymap.set("v", "<leader>t", 'y:BTags<Space><C-R>"<CR>')
vim.keymap.set("v", "<leader>T", 'y:Tags<Space><C-R>"<CR>')

-- Sort result of Files based on proximity to current file
vim.cmd([[
    function! s:list_cmd()
        let base = fnamemodify(expand('%'), ':h:.:S')
        return base == '.' ? 'fd --type f --hidden' : printf('fd --type f --hidden | proximity-sort %s', expand('%'))
    endfunction

    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
        \                               'options': '--tiebreak=index'}, <bang>0)
]])

vim.g.fzf_layout = {
    down = "~40%",
}

vim.g.fzf_action = {
    ["ctrl-t"] = "tab split",
    ["ctrl-s"] = "split",
    ["ctrl-v"] = "vsplit",
}

vim.g.fzf_colors = {
    fg = { "fg", "Normal" },
    bg = { "bg", "Normal" },
    hl = { "fg", "Comment" },
    info = { "fg", "PreProc" },
    border = { "fg", "Ignore" },
    prompt = { "fg", "Conditional" },
    pointer = { "fg", "Exception" },
    marker = { "fg", "Keyword" },
    spinner = { "fg", "Label" },
    header = { "fg", "Comment" },
    ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
    ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
    ["hl+"] = { "fg", "Statement" },
}
