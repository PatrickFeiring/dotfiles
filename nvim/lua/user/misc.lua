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
