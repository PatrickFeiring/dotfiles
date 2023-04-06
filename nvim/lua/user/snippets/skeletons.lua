-- Skeleton setups
--
-- We make use of luasnip as a simple templating language, in order to parameterize
-- the templates, and to be able to jump to places where content needs to be inserted.

local luasnip = prequire("luasnip")

if not luasnip then
    return
end

local choice = luasnip.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local i = luasnip.insert_node
local t = luasnip.text_node
local s = luasnip.snippet

local skeleton_group = vim.api.nvim_create_augroup(
    "skeletons",
    { clear = true }
)

local function read_skeleton_file(name)
    local path = vim.fn.stdpath("config") .. "/templates/" .. name

    if vim.fn.filereadable(path) == 1 then
        return table.concat(vim.fn.readfile(path), "\n")
    else
        return nil
    end
end

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
    pattern = ".editorconfig",
    group = skeleton_group,
    callback = function(_)
        local skeleton = read_skeleton_file("skeleton.editorconfig")

        if skeleton then
            luasnip.snip_expand(s(
                "",
                fmt(skeleton, {
                    indent_style = choice(1, {
                        t("space"),
                        t("tab"),
                    }),
                    indent_size = i(),
                })
            ))
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
    pattern = "*.stories.ts",
    group = skeleton_group,
    callback = function(_)
        local skeleton = read_skeleton_file("skeleton.stories.ts")

        if not skeleton then
            return
        end

        local current_basename = vim.fn.expand("%:t")
        local component_name = string.match(
            current_basename,
            "([^%.]*)%.stories%.ts"
        )

        if not component_name then
            return
        end

        local current_directory = vim.fn.expand("%:p:h")
        local component_basepath = current_directory .. "/" .. component_name

        local framework
        local extension

        if vim.fn.filereadable(component_basepath .. ".vue") == 1 then
            framework = "vue3"
            extension = "vue"
        elseif vim.fn.filereadable(component_basepath .. ".svelte") == 1 then
            framework = "svelte"
            extension = "svelte"
        else
            return
        end

        luasnip.snip_expand(s(
            "",
            fmt(skeleton, {
                framework = t(framework),
                component = t(component_name),
                extension = t(extension),
                default_story = i(1),
                final_position = i(2),
            }, {
                delimiters = "|$",
            })
        ))
    end,
})

local function create_storybook()
    -- If current filename has not been set, we opt out
    if vim.fn.expand("%") == "" then
        return
    end

    local basename = vim.fn.expand("%:r")
    local storybook_file = basename .. ".stories.ts"

    -- Make sure current extension makes sense in a storybook setting
    local ft = vim.bo.filetype

    if ft == "vue" or ft == "svelte" or ft == "ts" then
        vim.cmd("vnew " .. storybook_file)
    end
end

vim.api.nvim_create_user_command(
    "MakeStorybook",
    create_storybook,
    { nargs = 0 }
)
