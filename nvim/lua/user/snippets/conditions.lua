local M = {}

local conditions = require("luasnip.extras.conditions")

M.filetype_is = function(filetype)
    local function condition(line_to_cursor, matched_trigger)
        return vim.bo.filetype == filetype
    end

    return conditions.make_condition(condition)
end

return M
