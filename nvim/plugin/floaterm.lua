({
    "akinsho/toggleterm.nvim",
    config = function()
        local tt = require("toggleterm")
        vim.keymap.set({ "n", "t" }, "<M-w>", function() tt.toggle() end, { desc = "Toggle Floating Terminal" })
        tt.setup({ direction = "float" })
    end,
}).config()
