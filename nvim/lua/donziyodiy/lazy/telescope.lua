return {
    "nvim-telescope/telescope.nvim",

    version = "*",
    lazy = false,

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local notes = require("donziyodiy.notes")

        telescope.setup({})

        vim.keymap.set("n", "<leader>pf", builtin.find_files)
        vim.keymap.set("n", "<C-p>", builtin.git_files)

        vim.keymap.set("n", "<leader>pws", function()
            builtin.grep_string({
                search = vim.fn.expand("<cword>"),
            })
        end)

        vim.keymap.set("n", "<leader>pWs", function()
            builtin.grep_string({
                search = vim.fn.expand("<cWORD>"),
            })
        end)

        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({
                search = vim.fn.input("Grep > "),
            })
        end)

        vim.keymap.set("n", "<leader>vh", builtin.help_tags)

        vim.keymap.set("n", "<leader>nn", function()
            notes.new(0)
        end, { desc = "New note for today" })

        vim.keymap.set("n", "<leader>ny", function()
            notes.new(-1)
        end, { desc = "New note for yesterday" })

        vim.keymap.set("n", "<leader>nt", function()
            notes.new(1)
        end, { desc = "New note for tomorrow" })

        vim.keymap.set("n", "<leader>nf", function()
            notes.find()
        end, { desc = "Find all notes" })

        vim.keymap.set("n", "<leader>n0", function()
            notes.find(0)
        end, { desc = "Find today's notes" })

        vim.keymap.set("n", "<leader>n-", function()
            notes.find(-1)
        end, { desc = "Find yesterday's notes" })

        vim.keymap.set("n", "<leader>n+", function()
            notes.find(1)
        end, { desc = "Find tomorrow's notes" })

        vim.keymap.set("n", "<leader>ng", function()
            notes.grep()
        end, { desc = "Search inside notes" })
    end,
}
