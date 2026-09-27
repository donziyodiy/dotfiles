vim.opt.langmap = table.concat({
    "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}, ",")

vim.opt.langremap = false

local punctuation = {
    ["ё"] = "`",
    ["Ё"] = "~",

    ["х"] = "[",
    ["Х"] = "{",
    ["ъ"] = "]",
    ["Ъ"] = "}",

    ["ж"] = ";",
    ["Ж"] = ":",
    ["э"] = "'",
    ["Э"] = '"',

    ["б"] = ",",
    ["Б"] = "<",
    ["ю"] = ".",
    ["Ю"] = ">",

    ["."] = "/",
    [","] = "?",
}

for russian, english in pairs(punctuation) do
    vim.keymap.set(
        { "n", "x", "o" },
        russian,
        english,
        {
            remap = true,
            silent = true,
        }
    )
end

local abbreviations = {
    ["ив"] = "bd",
    ["ит"] = "bn",
    ["й"] = "q",
    ["йф"] = "qa",
    ["ц"] = "w",
    ["цй"] = "wq",
}

for russian, english in pairs(abbreviations) do
    vim.cmd(
        ("cnoreabbrev <expr> %s " ..
            "getcmdtype() ==# ':' && getcmdline() ==# '%s' ? '%s' : '%s'")
        :format(russian, russian, english, russian)
    )
end

return {}
