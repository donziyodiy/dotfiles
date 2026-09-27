local M = {}

M.notes_dir = vim.fn.expand("~/Documents/Notes")

local function date_with_offset(offset)
    return os.date("%Y-%m-%d", os.time() + offset * 86400)
end

local function short_uuid()
    local output = vim.fn.systemlist({ "uuidgen" })

    if vim.v.shell_error == 0 and output[1] then
        return output[1]:sub(1, 8):lower()
    end

    local value = table.concat({
        tostring(vim.uv.hrtime()),
        tostring(vim.fn.getpid()),
        tostring(math.random()),
    }, "-")

    return vim.fn.sha256(value):sub(1, 8)
end

function M.new(offset)
    offset = offset or 0

    vim.fn.mkdir(M.notes_dir, "p")

    local note_date = date_with_offset(offset)
    local filename
    local path

    repeat
        filename = string.format(
            "%s-%s.md",
            note_date,
            short_uuid()
        )

        path = M.notes_dir .. "/" .. filename
    until vim.fn.filereadable(path) == 0

    vim.cmd.edit(vim.fn.fnameescape(path))
end

function M.find(offset)
    vim.fn.mkdir(M.notes_dir, "p")

    local options = {
        cwd = M.notes_dir,
        prompt_title = "All Notes",
        hidden = true,
        no_ignore = true,
    }

    if offset ~= nil then
        local note_date = date_with_offset(offset)

        options.prompt_title = note_date .. " Notes"
        options.find_command = {
            "find",
            ".",
            "-maxdepth",
            "1",
            "-type",
            "f",
            "-name",
            note_date .. "-*.md",
            "-printf",
            "%f\n",
        }
    end

    require("telescope.builtin").find_files(options)
end

function M.grep()
    vim.fn.mkdir(M.notes_dir, "p")

    require("telescope.builtin").live_grep({
        cwd = M.notes_dir,
        prompt_title = "Search Notes",
    })
end

return M
