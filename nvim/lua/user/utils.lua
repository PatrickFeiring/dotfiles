local M = {}

function M.in_table(value, table)
    for i, v in ipairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

function M.get_tools_listed_in_pyproject()
    local tools = {
        black = false,
        isort = false,
        mypy = false,
    }

    local path = vim.loop.cwd() .. "/pyproject.toml"

    local f = io.open(path, "r")

    if f == nil then
        return {}
    end

    for line in f:lines() do
        if line == "[tool.black]" then
            tools["black"] = true
        elseif line == "[tool.isort]" then
            tools["isort"] = true
        elseif line == "[tool.mypy]" then
            tools["mypy"] = true
        end
    end

    io.close(f)

    return tools
end

function M.has_project_file(path)
    local f = io.open(path, "r")

    if f == nil then
        return false
    end

    io.close(f)

    return true
end

return M
