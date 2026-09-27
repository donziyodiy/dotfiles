local keys = {
    { "<C-a>", function() require("harpoon"):list():add() end },
    { "<C-h>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end },
}

for i = 1, 5, 1 do
    table.insert(keys, { "<C-" .. i .. ">", function() require("harpoon"):list():select(i) end })
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = "nvim-lua/plenary.nvim",
    keys = keys,
    config = function() require("harpoon"):setup() end,
}
