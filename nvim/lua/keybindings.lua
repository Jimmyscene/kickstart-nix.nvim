local maps = {

    { "n", "<Esc>", "<cmd>nohlsearch<CR>" },
    -- Diagnostic keymaps
    {
        "n",
        "<leader>qo",
        vim.diagnostic.setloclist,
        { desc = "Open diagnostic [Q]uickfix list" },
    },
    {
        "n",
        "<leader>qn",
        function() vim.cmd("cnext") end,
        { desc = "Move to [Q]uickfix [N]ext diagnostic. " },
    },
    {
        "n",
        "<leader>qp",
        function() vim.cmd("cprev") end,
        { desc = "Move to [Q]uickfix [N]ext diagnostic. " },
    },
    {
        "n",
        "<leader>gl",
        function() vim.diagnostic.open_float() end,
        { desc = "Open virtual text in a floating window" },
    },

    -- Bind <leader>y to copy to the system clipboard in both normal and visual modes
    { { "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true } },
    { { "n", "v" }, "<leader>Y", '"+y$', { noremap = true, silent = true } },

    -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
    -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
    -- is not what someone will guess without a bit more experience.
    { "t", "<C-W>", "<C-\\><C-n>", { desc = "Exit terminal mode" } },
    { "t", "<C-h>", [[<Cmd>wincmd h<CR>]] },
    { "t", "<C-j>", [[<Cmd>wincmd j<CR>]] },
    { "t", "<C-k>", [[<Cmd>wincmd k<CR>]] },
    { "t", "<C-l>", [[<Cmd>wincmd l<CR>]] },

    --  See `:help wincmd` for a list of all window commands
    { "n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" } },
    { "n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" } },
    { "n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" } },
    { "n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" } },
    { "n", "<C-q>", "<C-w><C-q>", { desc = "Close current window" } },
    { "n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "Open a new tab" } },
    { "n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "close active tab" } },

    { "n", "n", "nzz" },
    { "n", "N", "Nzz" },
    { "n", "*", "*zz" },
    { "n", "#", "#zz" },
    { "n", "g*", "g*zz" },
    { "n", "g*", "g*zz" },
    { "n", "gd", "gdzz" },

    -- Stay in indent mode
    { "v", "<", "<gv" },
    { "v", ">", ">gv" },
    { "x", "p", [["_dP]] },
    { { "n", "o", "x" }, "c", [["_c]] },
    { { "n", "o", "x" }, "C", [["_C]] },

    { { "n", "o", "x" }, "<s-h>", "^" },
    { { "n", "o", "x" }, "<s-l>", "g_" },
}

local function merge(table, table2)
    for k, v in pairs(table2) do
        table[k] = v
    end
    return table
end

for _, options in pairs(maps) do
    local mode = options[1]
    local lhs = options[2]
    local rhs = options[3]
    local opts = merge(options[4] or {}, { silent = true })
    vim.keymap.set(mode, lhs, rhs, opts)
end
