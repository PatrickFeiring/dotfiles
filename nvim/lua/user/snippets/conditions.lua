local M = {}

local conditions = require("luasnip.extras.conditions")

M.filetype_is = function(filetype)
    local function condition()
        return vim.bo.filetype == filetype
    end

    return conditions.make_condition(condition)
end

return M
