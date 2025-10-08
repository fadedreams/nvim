-- Editing
vim.api.nvim_set_keymap("v", "$", "g_", { noremap = true, silent = true })
vim.keymap.set("x", "p", "pgvy") -- yanked back into the register.
vim.api.nvim_set_keymap("n", "<c-p>", ":put!<cr>", { noremap = true, silent = true }) --paste above
vim.api.nvim_set_keymap("n", "<leader>p", ":put<cr>", { noremap = true, silent = true }) --paste below
vim.api.nvim_set_keymap("i", "<c-p>", "<c-r>+", { noremap = true }) --system clipboard

vim.keymap.set("n", "dw", "vb_d") -- Delete a word backwards
vim.keymap.set("x", "D", '"_d', { desc = "delete forever" })
vim.keymap.set("n", "x", '"_x', { noremap = true }) -- delete

-- Navigation
vim.keymap.set("n", "gh", "_", {desc = "Go to start of line"})
vim.keymap.set("n", "gl", "$", {desc = "Go to end of line"})

-- Jumping pages keeps cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc = "Jump page down"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc = "Jump page up"})

-- Keep search terms in the middle of the screen
vim.keymap.set("n", "n", "nzzzv", {desc = "Jump to next search term"})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Jump to previous search term"})

-- Toggle highlighting search
-- vim.keymap.set("n", "<leader>ih", ":set hlsearch!<CR>", {desc = "Toggle highlighting search"})

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move line down"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move line up"})
vim.keymap.set("n", "J", "mzJ`z")

-- Swap lines
vim.keymap.set("n", "<c-a-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<c-a-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<c-a-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<c-a-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Stay in indent mode.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Esc
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set({"i", "s"}, "<Esc>", function()
    vim.snippet.stop()
    return "<Esc>"
end, {expr = true, desc = "Close snippet session"})

--save
vim.keymap.set("n", "<c-w>", ":w<CR>", { noremap = true })
vim.keymap.set("i", "<c-w>", "<Esc>:w<CR>", { noremap = true })

-- save all
-- vim.keymap.set("n", "<a-s>", ":wa<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<a-s>", "<Esc>:wa<CR>i", { noremap = true, silent = true })

--quit do not use c-q > visual
vim.keymap.set("n", "<a-q>", ":q<CR>", { noremap = true })
vim.keymap.set("i", "<a-q>", "<Esc>:q<CR>", { noremap = true })

--toggler
vim.keymap.set("n", "<leader>ir", ":set relativenumber!<CR>",
  { noremap = true, silent = true,
  desc="Toggle relativenumber" })

vim.keymap.set('n', '<leader>ic', function()
    local cc = vim.opt.colorcolumn:get()
    if cc[1] and cc[1] == '80' then
        vim.opt.colorcolumn = ''
    else
        vim.opt.colorcolumn = '80'
    end
end, { desc = 'Toggle Colorcolumn 80' })


vim.keymap.set("n", "<leader>ig", function()
    local active_bg = vim.o.background
    if active_bg == "dark" then
        vim.cmd("set background=light")
    else
        vim.cmd("set background=dark")
    end
end, {desc = "Toggle background"})

--whitespace
vim.keymap.set("n", "<leader>wc", function()
	if vim.opt.list:get() then
		vim.opt.list = false
	else
		vim.opt.listchars = { tab = "»·", trail = "·", nbsp = "_", eol = "¬" }
		vim.opt.list = true
	end
end, { desc = "Toggle custom listchars" })
vim.keymap.set("n", "<leader>wl", function() vim.opt.list = not vim.opt.list:get() end, { desc = "Show List" })

vim.opt.listchars = { trail = "·", nbsp = "␣" } --^I:tabs
vim.keymap.set("n", "<leader>ww", "<cmd>%s/\\r\\n\\?/\\n/g | %s/\\^M//g | %s/\\s\\+$//g",
  { desc = "Remove CR, literal ^M, trailing whitespace" })
vim.keymap.set("n", "<leader>wc", "<cmd>set ff=unix <cr>", { desc = "Convert to Unix format" })

-- Save without formatting
vim.keymap.set("n", "<leader>ws", ":noautocmd w<CR>", {desc = "Save without formatting"})

--rsi
vim.keymap.set("i", "<a-h>", "<Left>", { noremap = true, silent = true })
vim.keymap.set("i", "<a-j>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("i", "<a-k>", "<Up>", { noremap = true, silent = true })
vim.keymap.set("i", "<a-l>", "<Right>", { noremap = true, silent = true })

vim.keymap.set('c', '<c-a>', '<Home>')
vim.keymap.set('c', '<c-e>', '<End>')
vim.keymap.set('i', '<c-a>', '<Home>')
vim.keymap.set('i', '<c-e>', '<End>')

vim.keymap.set('i', '<a-u>', '<C-u>', { desc = 'Delete to start of line' })    -- Ctrl-u to delete to start of line
vim.keymap.set('i', '<a-k>', '<C-o>d$', { desc = 'Delete to end of line' })
vim.keymap.set('i', '<a-d>', '<C-o>db', { desc = 'Delete word backward' })
vim.keymap.set('i', '<a-x>', '<Del>', { desc = 'Delete character under cursor' })


-- Sources current buffer
-- keyset("n", "<leader><leader>x", function()
--     vim.cmd("so")
-- end, {desc = "Source current buffer"})
-- keyset("n", "<leader>X", ":.lua<CR>", {desc = "Source current line"})
-- keyset("v", "<leader>X", ":.lua<CR>", {desc = "Source current selection"})
