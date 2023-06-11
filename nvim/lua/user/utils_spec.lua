local utils = require("user.utils")

describe("project path sorting", function()
    it("prefers files first in common folders", function()
        assert.is_true(utils.sort_project_paths({
            type = "directory",
            path = "src/module/user/",
        }, {
            type = "file",
            path = "src/module/component.ts",
        }))
    end)

    it("prefers directories first in routes folder", function()
        assert.is_true(utils.sort_project_paths({
            type = "file",
            path = "src/routes/+page.svelte",
        }, {
            type = "directory",
            path = "src/routes/user/",
        }))
    end)

    it("orders svelte files by running order", function()
        assert.is_true(utils.sort_project_paths({
            type = "file",
            path = "src/routes/+page.ts",
        }, {
            type = "file",
            path = "src/routes/+page.svelte",
        }))

        assert.is_true(utils.sort_project_paths({
            type = "file",
            path = "src/routes/+page.server.ts",
        }, {
            type = "file",
            path = "src/routes/+page.ts",
        }))
    end)
end)
