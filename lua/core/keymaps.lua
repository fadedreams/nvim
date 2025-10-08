-- yanked back into the register.
vim.keymap.set("x", "p", "pgvy")

-- keyset('n', '-', function()
--   local cur_file = vim.fn.expand('%:t')
--   vim.cmd.Ex()
--   vim.fn.search('^' .. cur_file .. '$')
-- end, {desc = 'Open Netrw'})
-- keyset('n', '<C-c>', vim.cmd.Rex, {desc = 'Open last visited file'})

vim.keymap.set("c", "<C-g>", "<C-f>", {desc = "Edit command in cmdline mode"})
-- keyset("n", "<C-s>", "gg<S-v>G", {desc = "Select all"})

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move line down"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move line up"})
vim.keymap.set("n", "J", "mzJ`z")

-- Jumping pages keeps cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc = "Jump page down"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc = "Jump page up"})

-- Keep search terms in the middle of the screen
vim.keymap.set("n", "n", "nzzzv", {desc = "Jump to next search term"})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Jump to previous search term"})


-- Sources current buffer
-- keyset("n", "<leader><leader>x", function()
--     vim.cmd("so")
-- end, {desc = "Source current buffer"})
-- keyset("n", "<leader>X", ":.lua<CR>", {desc = "Source current line"})
-- keyset("v", "<leader>X", ":.lua<CR>", {desc = "Source current selection"})

-- Toggle highlighting search
vim.keymap.set("n", "<leader>th", ":set hlsearch!<CR>", {desc = "Toggle highlighting search"})

-- Save without formatting
vim.keymap.set("n", "<leader>wf", ":noautocmd w<CR>", {desc = "Save without formatting"})

vim.keymap.set("n", "<leader>ug", function()
    local active_bg = vim.o.background
    if active_bg == "dark" then
        vim.cmd("set background=light")
    else
        vim.cmd("set background=dark")
    end
end, {desc = "Toggle background"})

vim.keymap.set({"i", "s"}, "<Esc>", function()
    vim.snippet.stop()
    return "<Esc>"
end, {expr = true, desc = "Close snippet session"})

vim.keymap.set("n", "gh", "_", {desc = "Go to start of line"})
vim.keymap.set("n", "gl", "$", {desc = "Go to end of line"})


