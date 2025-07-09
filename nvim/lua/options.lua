-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.api.nvim_set_keymap("", ",", "<leader>", {})
vim.g.maplocalleader = "\\"

vim.opt.wrap = false
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Save quietly when remote?
vim.g.netrw_silent = 1

vim.g.netrw_banner = 0

local function paste() return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end

vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = { -- TODO: doesnt seem to work
        -- ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        -- ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        ["+"] = paste,
        ["*"] = paste,
    },
}

-- Make line numbers default vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
vim.opt.relativenumber = true
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
-- hold opt in iterm to do regular selection
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- disable searchcount [3/17]
vim.opt.shortmess:append("S")

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
--  jimmyscene: Sometimes it takes me a long time to think about stuff ok
vim.opt.timeoutlen = 4000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.colorcolumn = "80"

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
