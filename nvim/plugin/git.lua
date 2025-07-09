-- Function to display output in a new scratch buffer
local function show_output(output, title)
    -- Save the current window
    vim.notify(table.concat(output, "\n"), vim.log.levels.info, { title = title, timeout = 5000 })
end

-- Start a job
local function run_job(command)
    local output = {}
    vim.fn.jobstart(command, {
        on_stdout = function(_, data)
            for _, line in ipairs(data) do
                if line ~= "" then
                    table.insert(output, line)
                end
            end
        end,
        on_stderr = function(_, data)
            for _, line in ipairs(data) do
                if line ~= "" then
                    table.insert(output, line)
                end
            end
        end,
        on_exit = function(_, code) show_output(output, command .. "(exit code " .. code .. ")") end,
    })
    vim.notify("Ran " .. command, vim.log.levels.info)
end

local NeoGit = {
    "NeogitOrg/neogit",
    opts = {
        disable_commit_confirmation = true,
        disable_insert_on_commit = "auto",
        disable_hint = true,
        mappings = {
            popup = {
                ["P"] = "PullPopup",
                ["p"] = "PushPopup",
            },
            status = {
                ["C"] = function() return run_job("codereview") end,
            },
        },
    },
}
local neogit = require("neogit")

vim.keymap.set("n", "<leader>gg", function() neogit.open({ kind = "floating" }) end)
vim.keymap.set("n", "<leader>gt", function() neogit.open({ kind = "tab" }) end)
neogit.setup(NeoGit.opts)

local GitSigns = {
    "lewis6991/gitsigns.nvim",
    keys = {},
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
    },
}

local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>hs", function() gitsigns.stage_hunk() end)
vim.keymap.set("n", "<leader>hr", function() gitsigns.reset_hunk() end)
vim.keymap.set("n", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
vim.keymap.set("n", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
vim.keymap.set("n", "<leader>hS", function() gitsigns.stage_buffer() end)
vim.keymap.set("n", "<leader>hu", function() gitsigns.undo_stage_hunk() end)
vim.keymap.set("n", "<leader>hR", function() gitsigns.reset_buffer() end)
vim.keymap.set("n", "<leader>hp", function() gitsigns.preview_hunk() end)
vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end)
vim.keymap.set("n", "<leader>tb", function() gitsigns.toggle_current_line_blame() end)
vim.keymap.set("n", "<leader>hd", function() gitsigns.diffthis() end)
vim.keymap.set("n", "<leader>hD", function() gitsigns.diffthis("~") end)
vim.keymap.set("n", "<leader>td", function() gitsigns.toggle_deleted() end)

gitsigns.setup(GitSigns.opts)
