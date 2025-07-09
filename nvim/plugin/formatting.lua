local AutoFormat = { -- Autoformat
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
    require("conform").setup({
        notify_on_error = true,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true, sh = true, yaml = true }
            local shouldDisable = disable_filetypes[vim.bo[bufnr].filetype]
            local envDisable = os.getenv("DISABLE_FORMAT_ON_SAVE")
            if shouldDisable or (envDisable ~= nil) then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_fallback = true,
                }
            end
        end,
        log_level = vim.log.levels.DEBUG,
        formatters = {
            yamlfmt = {
                prepend_args = {
                    "--formatter",
                    "indent=4",
                    "--formatter",
                    "indentless_arrays=true",
                    "--formatter",
                    "retain_line_breaks_single=true",
                },
            },
            black = {
                prepend_args = { "--fast" },
            },
            nixfmt = {
                prepend_args = {
                    "--indent",
                    "4",
                },
            },
        },
        formatters_by_ft = {
            c = { "uncrustify" },
            lua = { "stylua" },
            python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
            nix = { "nixfmt" },
            sql = { "sql_formatter" },
            toml = { "taplo" },
            xml = { "xmlformat" },
            yaml = { "yamlfmt" },
        },
    })
    end
}
vim.keymap.set("n","<leader>F", function() require("conform").format({ async = true, lsp_fallback = true }) end, {desc = "[F]ormat buffer"})
AutoFormat.config()
