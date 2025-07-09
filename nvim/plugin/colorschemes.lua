-- Function to merge two tables
local function mergeTables(table1, table2)
    -- Iterate over all key-value pairs in table2 and insert them into table1
    for key, value in pairs(table2) do
        table1[key] = value
    end
    return table1
end
local goodSchemes = {
    -- Something wrong with the gutters being pink
    mestizo = { "Anfigeno/mestizo.nvim" },
    vague = { "vague2k/vague.nvim", name = "vague-nvim" },
    catppuccin = { "catppuccin/nvim", scheme = "catppuccin-macchiato", name = "catppuccin-nvim" },
    tokyonight = { "folke/tokyonight.nvim", scheme = "tokyonight-storm" }, --scheme = "tokyonight-storm" },
    -- jimmyscene: overrides don't work as of 2024-05-24
    neofusion = {
        "diegoulloao/neofusion.nvim",
        opts = {
            palette_overrides = {
                dark0 = "#25273C",
            },
        },
    },
    -- low contrast ehh
    aki = { "comfysage/aki" },
    kanagawa = {
        "rebelot/kanagawa.nvim",
        opts = {
            -- theme = "wave",
            background = { -- map the value of 'background' option to a theme
                -- dark = "wave",
                -- light = "lotus",
            },
        },
    },
    everforest = {
        "neanias/everforest-nvim",
        config = function()
            require("everforest").setup({
                background = "medium",
                ui_contrast = "high",
            })
        end,
    },
    edge = { "sainnhe/edge" },
    bluloco = { "uloco/bluloco.nvim" },
    komau = { "ntk148v/komau.vim" },
    oldworld = { "dgox16/oldworld.nvim" },
    darkrose = { "water-sucks/darkrose.nvim" },
    evergarden = {
        "everviolet/nvim",
        name = "evergarden",
        config = function()
            require("evergarden").setup({
                theme = {
                    variant = "spring", -- 'winter'|'fall'|'spring'|'summer'
                    accent = "green",
                },
            })
        end,
    },
    nordern = { "fcancelinha/nordern.nvim" },
    jellybeans = { "WTFox/jellybeans.nvim" },
    newpaper = { "yorik1984/newpaper.nvim", opts = {
        style = "dark",
    } },
    embark = { -- better catppuccin
        "embark-theme/vim",
        name = "embark-vim",
        config = function() vim.cmd.colorscheme("embark") end,
    },
    pinkmare = {
        "matsuuu/pinkmare",
        config = function() vim.cmd.colorscheme("pinkmare") end,
    },
    aurora = {
        "ray-x/aurora",
        config = function() vim.cmd.colorscheme("aurora") end,
    },
}
local override = nil
-- local selection = "bluloco"
local selection = "evergarden"
local currentScheme = goodSchemes[selection]
local ColorScheme = mergeTables(currentScheme, {
    lazy = false,
    priority = 1000,
    opts = currentScheme.opts or {},
    config = currentScheme.config or nil,
})

function ColorScheme.init()
    local scheme = override or currentScheme.scheme or selection
    vim.opt.termguicolors = true
    vim.cmd.colorscheme(scheme)
end

ColorScheme.config()
ColorScheme.init()
