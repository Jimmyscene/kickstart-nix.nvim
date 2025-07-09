local function require_with_opts(mod, opts) require(mod).setup(opts) end

require_with_opts("zen-mode", { window = { width = 0.66 } })
require_with_opts("ibl", {})
require_with_opts("stickybuf", {})
require_with_opts("jupytext", {})
require_with_opts("oil", {})

-- require("render-markdown").setup({
--     heading = { icons = { "󰼏 ", "󰎨 " }, backgrounds = {} },
-- })
require("git-conflict").setup({
    default_mappings = true, -- disable buffer local mapping created by this plugin
    default_commands = true, -- disable commands created by this plugin
    disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
    debug = false,
    list_opener = "copen", -- command or function to open the conflicts list
    highlights = { -- They must have background color, otherwise the default color will be used
        incoming = "DiffAdd",
        current = "DiffText",
    },
})

require("tiny-inline-diagnostic").setup({
    preset = "powerline",
    options = {
        show_all_diags_on_cursorline = true,
        multilines = true,
    },
})
vim.diagnostic.config({ virtual_text = false })

require_with_opts("snacks", {
    notifier = {
        enabled = true,
        width = { max = 0.7 },
    },
    styles = {
        notification = {
            wo = { wrap = true }, -- Wrap notifications
        },
    },
    bufdelete = {
        enabled = true,
    },
})

require("overseer").setup()
require("marks").setup()
require_with_opts("remote-nvim", {
    offline_mode = {
        enabled = false,
        no_github = false,
    },
})

vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle DAP Breakpoint" })
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "DAP Continue" })
vim.keymap.set("n", "<leader>dn", function() require("dap").step_over() end)
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end)
vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end)
local dap, dapui = require("dap"), require("dapui")
dapui.setup()
dap.listeners.before.attach.dapui_config = function() dapui.open() end
-- dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

dap.listeners.before.initialize.launch_tasks = function()
    -- TODO:
end
dap.listeners.after.event_terminated.launch_tasks = function()
    -- TODO:
end
dap.adapters.python = function(cb, config)
    if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        local localhost = "127.0.0.1"
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or localhost
        if host == "localhost" then --NB: Idk why debugpy doesnt like my localhost
            host = localhost
        end

        cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
                source_filetype = "python",
            },
        })
    else
        cb({
            type = "executable",
            command = "python3",
            args = { "-m", "debugpy.adapter" },
            options = {
                source_filetype = "python",
            },
        })
    end
end
