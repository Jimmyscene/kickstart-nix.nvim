({
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
        require("window-picker").setup({
            selection_chars = "1234567890;",
            filter_rules = {
                include_current_win = false,
                autoselect_one = true,
                -- filter using buffer options
                bo = {
                    -- if the file type is one of following, the window will be ignored
                    filetype = {
                        "neo-tree",
                        "neo-tree-popup",
                        "notify",
                    },
                    -- if the buffer type is one of following, the window will be ignored
                    buftype = { "terminal", "quickfix" },
                },
            },
        })
    end,
}).config()

vim.keymap.set("n", "<leader>op", function()
    require("mini.starter").close()
    require("neo-tree.command").execute({
        action = "show",
        reveal = true,
        toggle = true,
    })
end, { desc = "NeoTree reveal toggle" })

return {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    version = "*",
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = true, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = {
                        "node_modules",
                        "vendor",
                        ".vscode",
                    },
                    hide_by_pattern = { -- uses glob style patterns
                        --"*.meta",
                        "*/src/*/tsconfig.json",
                        ".mypy_cache**",
                    },
                    always_show = { -- remains visible even if other settings would normally hide it
                        ".gitignore",
                    },
                    never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                        ".DS_Store",
                        "thumbs.db",
                        "__pycache__",
                    },
                    never_show_by_pattern = { -- uses glob style patterns
                        --".null-ls_*",
                        "*/*.pyc",
                    },
                },
            },
        })
    end,
}
