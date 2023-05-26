local utils = require("user.utils")

describe("project path sorting", function()
    it("prefers files first in common folders", function()
        assert.is_false(utils.sort_project_paths({
            type = "file",
            path = "src/module/component.ts",
        }, {
            type = "directory",
            path = "src/module/user/",
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
end)
