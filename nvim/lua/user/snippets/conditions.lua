local M = {}

function M.and_(first, second)
    local function condition(line_to_cursor, matched_trigger)
        if first(line_to_cursor, matched_trigger) then
            return second(line_to_cursor, matched_trigger)
        else
            return false
        end
    end

    return condition
end

function M.or_(first, second)
    local function condition(line_to_cursor, matched_trigger)
        if first(line_to_cursor, matched_trigger) then
            return true
        else
            return second(line_to_cursor, matched_trigger)
        end
    end

    return condition
end

return M
