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

local groups = {
    {
        "+layout.server.ts",
        "+layout.ts",
        "+layout.svelte",
    },
    {
        "+page.server.ts",
        "+page.ts",
        "+page.svelte",
    },
}

function M.cycle_file_group(direction)
    direction = direction or "forward"

    local file_path = vim.fn.expand("%")

    local directory = vim.fn.fnamemodify(file_path, ":h")
    local basename = vim.fn.fnamemodify(file_path, ":t")

    for _, group in ipairs(groups) do
        for i, target_filename in ipairs(group) do
            if target_filename == basename then
                local start, stop, step

                if direction == "backward" then
                    start = i - 1
                    stop = 1
                    step = -1
                else
                    start = i + 1
                    stop = #group
                    step = 1
                end

                for j = start, stop, step do
                    local path = directory .. "/" .. group[j]

                    if vim.fn.filereadable(path) == 1 then
                        vim.cmd("edit " .. path)
                        return
                    end
                end

                return
            end
        end
    end
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

return M
