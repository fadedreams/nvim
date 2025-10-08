
vim.api.nvim_set_hl(0, "lazygitborder", {link = "floatborder"})
--vim.api.nvim_set_hl(0, "Normal", {bg = "NONE"})
vim.api.nvim_set_hl(0, "StatusLine", {bg = "NONE"})
vim.api.nvim_set_hl(0, "StatusLineNC", {bg = "NONE"})

-- Split window
vim.keymap.set("n", "<leader>ss", ":split<Return><C-w>w", {desc = "Split window horizontally"}) -- Horizontal
vim.keymap.set("n", "<leader>sv", ":vsplit<Return><C-w>w", {desc = "Split window vertically"})  -- Vertical


-- Resize splits
vim.keymap.set("n", "<M-Left>", "<C-w>5>", {desc = "Resize window (left)"})
vim.keymap.set("n", "<M-Right>", "<C-w>5<", {desc = "Resize window (right)"})
vim.keymap.set("n", "<M-Down>", "<C-w>5-", {desc = "Resize window (down)"})
vim.keymap.set("n", "<M-Up>", "<C-w>5+", {desc = "Resize window (up)"})

--nav
vim.keymap.set('n', '<c-Left>', '<C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<c-Right>', '<C-w>l', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<c-Up>', '<C-w>k', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<c-Down>', '<C-w>j', { desc = 'Move focus to the lower window' })

vim.keymap.set(
    "n",
    "<Leader>oe",
    ":silent !open %:p:h<CR>",
    { noremap = true, silent = true, desc = "[O]pen [E]xplorer" }
)

vim.keymap.set("n", "<F11>", ":only<CR>", { noremap = true, silent = true, desc = "Maximize window" })
