-- Credit goes where credit is due. This is a modified version of:
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html

-- Define highlight groups with the specified colors
vim.api.nvim_set_hl(0, "StatusLineAccent", { fg = "#7aa2f7", bg = "NONE" }) -- Normal
vim.api.nvim_set_hl(0, "StatusLineInsertAccent", { fg = "#0db9d7", bg = "NONE" }) -- Insert
vim.api.nvim_set_hl(0, "StatusLineVisualAccent", { fg = "#a487d8", bg = "NONE" }) -- Visual
vim.api.nvim_set_hl(0, "StatusLineReplaceAccent", { fg = "#d94a4a", bg = "NONE" }) -- Replace
vim.api.nvim_set_hl(0, "StatusLineCmdLineAccent", { fg = "#e0af68", bg = "NONE" }) -- Command
vim.api.nvim_set_hl(0, "StatusLineTerminalAccent", { fg = "#565f89", bg = "NONE" }) -- Terminal/Inactive
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#c0caf5", bg = "NONE" }) -- Default statusline
vim.api.nvim_set_hl(0, "StatusLineExtra", { fg = "#a9b1d6", bg = "NONE" }) -- Extra statusline components
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#db4b4b", bg = "NONE" }) -- LSP Errors
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#e0af68", bg = "NONE" }) -- LSP Warnings
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#0db9d7", bg = "NONE" }) -- LSP Info
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#1abc9c", bg = "NONE" }) -- LSP Hints
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#1abc9c", bg = "NONE" }) -- Git added
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e0af68", bg = "NONE" }) -- Git changed
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#db4b4b", bg = "NONE" }) -- Git deleted

-- Update statusline colors based on mode
local function update_mode_colors()
    local current_mode = vim.api.nvim_get_mode().mode
    local mode_color = "%#StatusLineAccent#"
    if current_mode == "n" then
        mode_color = "%#StatusLineAccent#"
    elseif current_mode == "i" or current_mode == "ic" then
        mode_color = "%#StatusLineInsertAccent#"
    elseif current_mode == "v" or current_mode == "V" or current_mode == "\22" then
        mode_color = "%#StatusLineVisualAccent#"
    elseif current_mode == "R" then
        mode_color = "%#StatusLineReplaceAccent#"
    elseif current_mode == "c" then
        mode_color = "%#StatusLineCmdLineAccent#"
    elseif current_mode == "t" or current_mode == "nt" then
        mode_color = "%#StatusLineTerminalAccent#"
    end
    return mode_color
end

-- Get the file path
local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
    if fpath == "" or fpath == "." then
        return " "
    end
    if string.find(fpath, "oil://") then
        fpath = string.gsub(fpath, "oil://", "")
    end
    fpath = fpath:gsub(vim.env.HOME, "~", 1)

    local is_wide = vim.api.nvim_win_get_width(0) > 80

    if not is_wide then
        fpath = vim.fn.pathshorten(fpath)
    end

    return string.format("%%<%s/", fpath)
end

-- Get the file name
local function filename()
    local fname = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.")
    if fname == "" or fname == "." then
        return ""
    end
    if string.find(fname, "oil://") then
        fname = string.gsub(fname, "oil://", "")
    end
    fname = fname:gsub(vim.env.HOME, "~", 1)

    local is_wide = vim.api.nvim_win_get_width(0) > 80

    if not is_wide then
        fname = vim.fn.pathshorten(fname)
    end

    return fname .. " "
end

-- LSP diagnostics
local function lsp()
    local count = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }

    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local hints = ""
    local info = ""

    if count["errors"] ~= 0 then
        errors = " %#DiagnosticSignError#" .. "E" .. count["errors"]
    end
    if count["warnings"] ~= 0 then
        warnings = " %#DiagnosticSignWarn#" .. "W" .. count["warnings"]
    end
    if count["hints"] ~= 0 then
        hints = " %#DiagnosticSignHint#" .. "H" .. count["hints"]
    end
    if count["info"] ~= 0 then
        info = " %#DiagnosticSignInfo#" .. "I" .. count["info"]
    end

    return errors .. warnings .. hints .. info .. "%#Statusline# "
end

-- Git status (requires gitsigns.nvim)
local function vcs()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
        return ""
    end
    local added = git_info.added and
        ("%#GitSignsAdd#" .. (Utils.icons.git.added or "+") .. " " .. git_info.added .. " ") or ""
    local changed = git_info.changed and
        ("%#GitSignsChange#" .. (Utils.icons.git.changed or "~") .. " " .. git_info.changed .. " ") or ""
    local removed = git_info.removed and
        ("%#GitSignsDelete#" .. (Utils.icons.git.deleted or "-") .. " " .. git_info.removed .. " ") or ""
    if git_info.added == 0 then
        added = ""
    end
    if git_info.changed == 0 then
        changed = ""
    end
    if git_info.removed == 0 then
        removed = ""
    end
    return table.concat({
        " ",
        Utils.icons.git.branch2 or "",
        " ",
        git_info.head,
        "  ",
        added,
        changed,
        removed,
    })
end

-- File type
local function filetype()
    return string.format(" %s ", vim.bo.filetype)
end

-- Modified indicator
local function modified()
    return "%m"
end

-- Line and column info
local function lineinfo()
    if vim.bo.filetype == "alpha" then
        return ""
    end
    return " %P %l:%c "
end

-- Character count
local function charcount()
    if vim.bo.filetype == "alpha" then
        return ""
    end
    local chars = vim.fn.wordcount().chars
    return string.format("%d", chars)
end

-- Statusline setup
local M = {}

---@param type "active" | "inactive" | "help" | "oil"
function M.setup(type)
    if type == "active" then
        return table.concat({
            update_mode_colors(),
            filename(),
            modified(),
            vcs(),
            "%#Statusline#",
            "%=%#StatusLineExtra#",
            lsp(),
            filetype(),
            lineinfo(),
            charcount(),
        })
    elseif type == "inactive" then
        return table.concat({
            "%#StatusLineTerminalAccent#",
            filename(),
            modified(),
        })
    elseif type == "help" then
        return table.concat({
            "%#Statusline#",
            filename(),
            "%#Statusline#",
            "%=%#StatusLineExtra#",
            filetype(),
            lineinfo(),
        })
    elseif type == "oil" then
        return table.concat({
            "%#Statusline#  ",
            filepath(),
        })
    end
end

-- Set the statusline
vim.o.statusline = "%!v:lua.require('statusline').setup('active')"

-- Handle inactive windows
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
        vim.wo.statusline = "%!v:lua.require('statusline').setup('active')"
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
        vim.wo.statusline = "%!v:lua.require('statusline').setup('inactive')"
    end,
})

-- Handle help and oil filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "oil" },
    callback = function(args)
        local type = args.match == "help" and "help" or "oil"
        vim.wo.statusline = "%!v:lua.require('statusline').setup('" .. type .. "')"
    end,
})

return M
