require("nvim-treesitter.install").prefer_git = true

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
    incremental_selection = {
        -- ensure we don't try to parse things in the command mode
        is_supported = function()
            local mode = vim.api.nvim_get_mode().mode
            if mode == "c" then
                return false
            end
            return true
        end,
    },
    ignore_install = { "norg", "norg_meta" },
    highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
})

require("treesitter-context").setup({
    max_lines = 3,
    multiline_threshold = 1,
    mode = "cursor",
    trim_scope = "inner",
})
