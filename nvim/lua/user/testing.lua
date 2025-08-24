local utils = require("user.utils")

local M = {}

function M.create_test_file()
    local stem = vim.fn.expand("%:r")
    local filename = vim.fn.expand("%:t:r")

    if filename == "" then
        vim.notify("Can not create test file for unsaved file", "error")
        return
    end

    if utils.count_number_of_large_windows() > 1 then
        vim.cmd("edit " .. stem .. ".test.ts")
    else
        vim.cmd("vnew " .. stem .. ".test.ts")
    end
end

vim.api.nvim_create_user_command("MakeTests", M.create_test_file, { nargs = 0 })

function M.create_stories_file()
    local stem = vim.fn.expand("%:r")
    local filename = vim.fn.expand("%:t:r")
    local extension = vim.fn.expand("%:e")

    if filename == "" then
        vim.notify("Can not setup stories for unsaved file", "error")
        return
    end

    local extension_map = {
        svelte = { "ts", "svelte" },
        vue = { "ts" },
        tsx = { "tsx" },
    }

    local stories_extension = extension_map[extension]

    if stories_extension == nil then
        vim.notify(
            string.format(
                "Can not setup stories for files with extension %s",
                extension
            ),
            "error"
        )
        return
    end

    if #stories_extension > 1 then
        -- TODO: handle
    else
        if utils.count_number_of_large_windows() > 1 then
            vim.cmd("edit " .. stem .. ".stories." .. stories_extension[1])
        else
            vim.cmd("vnew " .. stem .. ".stories." .. stories_extension[1])
        end
    end
end

vim.api.nvim_create_user_command(
    "MakeStories",
    M.create_stories_file,
    { nargs = 0 }
)

local template_group =
    vim.api.nvim_create_augroup("templates", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
    pattern = "*.stories.tsx",
    group = template_group,
    callback = function(_)
        local component = vim.fn.expand("%:t:r:r")

        vim.snippet.expand(([[
import type { Meta, StoryObj } from '@storybook/react-vite';
import {{component}} from './{{component}}.tsx';

const meta = {
    component: {{component}},
} satisfies Meta<typeof {{component}>;

export default meta;
type Story = StoryObj<typeof meta>;

export const $1 = {
    args: {
        $2
    }
} satisfies Story;]]):gsub("{{component}}", component))
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
    pattern = "*.stories.svelte",
    group = template_group,
    callback = function(_)
        local component = vim.fn.expand("%:t:r:r")

        vim.snippet.expand(([[
<script lang="ts" module>
	import {{component}} from './{{component}}.svelte';

	export const meta = {
		component: {{component}}
	};
</script>

<script lang="ts">
	import { Story, Template } from '@storybook/addon-svelte-csf';
</script>

<Story
	name="$1"
	args={{
		$2
	}}
/>]]):gsub("{{component}}", component))
    end,
})

vim.keymap.set("n", "gt", M.create_test_file)

vim.keymap.set("n", "<C-n>", function()
    vim.ui.select({ "test", "stories" }, {
        prompt = "Generate",
    }, function(choice)
        if choice == "test" then
            M.create_test_file()
        else
            M.create_stories_file()
        end
    end)
end)

return M
