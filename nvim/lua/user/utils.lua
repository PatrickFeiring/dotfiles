local M = {}

function M.get_tools_listed_in_pyproject()
    local tools = {
        black = false,
        isort = false,
        mypy = false,
        ruff = false,
    }

    local path = vim.uv.cwd() .. "/pyproject.toml"

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
        elseif line == "[tool.ruff]" then
            tools["ruff"] = true
        end
    end

    io.close(f)

    return tools
end

local function has_project_file(path)
    local f = io.open(path, "r")

    if f == nil then
        return false
    end

    io.close(f)

    return true
end

local cache = {}

---@param path string
function M.has_project_file(path)
    local entry = cache[path]

    if entry ~= nil then
        return entry
    end

    local fresh = has_project_file(path)
    cache[path] = fresh

    return fresh
end

function M.parse_path(path)
    local directory, basename = path:match("(.*/)(.*)")

    if not directory then
        basename = path
    end

    local stem
    local extensions

    local i = basename:find("%.")

    if i then
        stem = basename:sub(1, i - 1)
        extensions = basename:sub(i + 1)
    else
        stem = basename
    end

    return {
        directory = directory,
        basename = basename,
        stem = stem,
        extensions = extensions,
    }
end

local function are_paths_in_routes(a, b)
    return string.find(a.path, "src/routes/")
        and string.find(b.path, "src/routes/")
end

local function get_files_first_score(a, b)
    if a.type == b.type then
        return 0
    elseif a.type < b.type then
        return -1
    else
        return 1
    end
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

local function get_sort_score_by_filename(a)
    if a.type == "file" then
        local path = M.parse_path(a.path)

        for i, filename in ipairs(filename_order) do
            if path.basename == filename then
                return i
            end
        end
    end

    return #filename_order + 1
end

local extensions_order = {
    "vue",
    "svelte",
    "stories.ts",
}

local function get_sort_score_by_extension(target_extensions)
    for i, extensions in ipairs(extensions_order) do
        if target_extensions == extensions then
            return i
        end
    end

    return #extensions_order + 1
end

local function get_relative_sort_score_by_extensions(a, b)
    if a.type == "file" and b.type == "file" then
        local a_path = M.parse_path(a.path)
        local b_path = M.parse_path(b.path)

        if a_path.stem ~= b_path.stem then
            return 0
        end

        return get_sort_score_by_extension(a_path.extensions)
            - get_sort_score_by_extension(b_path.extensions)
    end

    return 0
end

---Sort project paths
function M.sort_project_paths(a, b)
    -- Sort by files first in Svelte routes folder
    -- https://www.reddit.com/r/sveltejs/comments/xltgyp/quality_of_life_tips_when_using_sveltekit_in_vs/
    local score_difference = get_files_first_score(a, b)

    if are_paths_in_routes(a, b) then
        score_difference = score_difference * -1
    end

    if score_difference ~= 0 then
        return score_difference < 0
    end

    local filename_score_difference = get_sort_score_by_filename(a)
        - get_sort_score_by_filename(b)

    if filename_score_difference ~= 0 then
        return filename_score_difference < 0
    end

    local extension_score_difference =
        get_relative_sort_score_by_extensions(a, b)

    if extension_score_difference ~= 0 then
        return extension_score_difference < 0
    end

    return a.path < b.path
end

function M.count_number_of_large_windows()
    local windows = vim.api.nvim_list_wins()
    local large_windows = 0

    for _, h in ipairs(windows) do
        if
            vim.api.nvim_win_get_width(h) > 35
            and vim.api.nvim_win_get_height(h) > 35
        then
            large_windows = large_windows + 1
        end
    end

    return large_windows
end

return M
