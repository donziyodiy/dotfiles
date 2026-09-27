return {
    {
        "erikbackman/brightburn.vim",
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                variant = "main",
                dark_variant = "main",

                styles = {
                    bold = true,
                    italic = false,
                    transparency = true,
                },
            })

            vim.cmd.colorscheme("rose-pine")
        end,
    },

    {
        "folke/tokyonight.nvim",
        opts = {
            style = "storm",
            transparent = true,
            terminal_colors = true,

            styles = {
                comments = { italic = false },
                keywords = { italic = false },
                sidebars = "dark",
                floats = "dark",
            },
        },
    },

    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        opts = {
            terminal_colors = true,
            undercurl = true,
            underline = false,
            bold = true,

            italic = {
                strings = false,
                emphasis = false,
                comments = false,
                operators = false,
                folds = false,
            },

            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true,
            contrast = "",
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = true,
        },
    },
}
