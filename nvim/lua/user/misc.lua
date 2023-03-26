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

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
    pattern = ".editorconfig",
    group = vim.api.nvim_create_augroup("skeletons", { clear = true }),
    callback = function(_)
        local path = vim.fn.stdpath("config")
            .. "/templates/skeleton.editorconfig"

        if vim.fn.filereadable(path) == 1 then
            vim.cmd(":silent 0r " .. path .. " | :norm Gd_")
        end
    end,
})
