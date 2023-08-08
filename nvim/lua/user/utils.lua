local M = {}

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

local function are_paths_in_routes(a, b)
    return string.find(a.path, "src/routes/")
        and string.find(b.path, "src/routes/")
end

local filename_order = {
    "+server.ts",
    "+layout.server.ts",
    "+layout.ts",
    "+layout.svelte",
    "+page.server.ts",
    "+page.ts",
    "+error.svelte",
    "+page.svelte",
}

local function get_sort_order_by_filename(a)
    if a.type == "file" then
        -- We could have done this with vim.fn.expand, but
        -- for now we'll try to avoid depending on neovim
        -- in this file
        local _, target_filename = a.path:match("(.*/)(.*)")

        for i, filename in ipairs(filename_order) do
            if target_filename == filename then
                return i
            end
        end

        return 0
    end
end

local function sort_directories_first(a, b)
    if a.type == b.type then
        return a.path < b.path
    else
        return a.type > b.type
    end
end

local function sort_files_first(a, b)
    if a.type == b.type then
        return a.path < b.path
    else
        return a.type < b.type
    end
end

---Sort project paths
function M.sort_project_paths(a, b)
    local special_a = get_sort_order_by_filename(a)
    local special_b = get_sort_order_by_filename(b)

    if special_a and special_b then
        return special_a < special_b
    end

    -- Sort by files first in Svelte routes folder
    -- https://www.reddit.com/r/sveltejs/comments/xltgyp/quality_of_life_tips_when_using_sveltekit_in_vs/
    if are_paths_in_routes(a, b) then
        return sort_directories_first(a, b)
    else
        return sort_files_first(a, b)
    end
end

return M
