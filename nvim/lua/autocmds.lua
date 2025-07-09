vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

-- Change directory to directory of current file
vim.api.nvim_create_user_command("Cd", ":cd %:p:h", {})

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Automatically enter insert mode when entering a terminal buffer",
    group = vim.api.nvim_create_augroup("TerminalInsertMode", { clear = true }),
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.api.nvim_command("startinsert")
        end
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function() vim.opt_local.conceallevel = 0 end,
})
function OpenFileInNonTerminalBuffer()
    -- Check if we're in a terminal buffer
    if vim.bo.buftype == "terminal" then
        -- Get the file under the cursor
        local file = vim.fn.expand("<cfile>")

        -- Open the file in a vertical split in a non-terminal buffer
        vim.cmd("vsplit " .. file)
    else
        -- Default 'gf' behavior in non-terminal buffers
        vim.cmd("normal! gf")
    end
end

-- Custom 'gf' behavior in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function() vim.keymap.set("n", "gf", OpenFileInNonTerminalBuffer, { buffer = 0 }) end,
})

-- Override :bd command with the custom function
vim.api.nvim_create_user_command("Bd", function() Snacks.bufdelete() end, {}) -- nargs = "?" allows an optional argument

-- Remap :bd to :Bd
vim.cmd("cnoreabbrev bd Bd")

-- TODO: Move this into lspconfig?
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = {
        "build.sh",
        "*.subpackage.sh",
        "PKGBUILD",
        "*.install",
        "makepkg.conf",
        "*.ebuild",
        "*.eclass",
        "color.map",
        "make.conf",
    },
    callback = function()
        vim.lsp.start({
            name = "termux",
            cmd = { "termux-language-server" },
        })
    end,
})

-- NOTE: Ensures that when exiting NeoVim, Zellij returns to normal mode
vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    command = "silent !zellij action switch-mode normal",
})
