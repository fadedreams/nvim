-- vim.keymap.set("n", "<Leader>bb", "<C-^>", { noremap = true, silent = true, desc = "Toggle last buffer" })
-- vim.keymap.set("n", "<leader>bdo", ":%bd|e#|bd#<CR>", { noremap = true, silent = true, desc = "delete other buffers" })
-- vim.keymap.set("n", "<leader>bda", ":%bd<CR>", { noremap = true, silent = true, desc = "delete all buffers" })
-- vim.keymap.set('n', "<c-\\>", '<cmd>bd<CR>', { desc = 'kill' })
-- vim.keymap.set("i", "<c-\\>", "<Esc>:bdelete<CR>", { desc = 'kill' })

-- Map Ctrl+Backspace to close the current buffer
vim.keymap.set('n', '<C-\\>', ':bdelete<CR>', { noremap = true, silent = true })-- Map Ctrl+Backspace to close the current buffer
vim.keymap.set('i', '<C-\\>', ':bdelete<CR>', { noremap = true, silent = true })

vim.keymap.set('n', "<c-c>", '<cmd>bd<CR>', { desc = 'kill' })
vim.keymap.set("i", "<c-c>", "<Esc>:bdelete<CR>", { desc = 'kill' })

vim.keymap.set('n', '<leader>bb', '<cmd>bd<CR>', { desc = '[D]elete Buffer' })
vim.keymap.set('n', '<leader>bn', '<cmd>ene<CR>', { desc = '[N]ew [B]uffer' })
vim.keymap.set('n', '<leader>bv', '<cmd>vnew<CR>', { desc = '[N]ew [B]uffer [V]split' })
vim.keymap.set('n', '<leader>bs', '<cmd>new<CR>', { desc = '[N]ew [B]uffer [H]orizontal' })
-- vim.keymap.set('n', '<C-[>', '<cmd>:bprevious<CR>', { desc = 'Previous buffer' })
-- vim.keymap.set('n', '<C-]>', '<cmd>:bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<C-h>', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set("i", "<C-h>", "<Esc>:bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-l>", "<Esc>:bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '\\[', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '\\]', ':bnext<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-\\>', ':bd<CR>', { noremap = true, silent = true })
-- vim.keymap.set("n", "<c-k>", ":bnext<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<c-j>", ":bprevious<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<c-l>", "<cmd>b#<cr>", { noremap = true, silent = true }) --Move to last buffer
-- vim.keymap.set("n", "<leader>bn", "<cmd>ene <bar> startinsert <cr>", { noremap = true, silent = true, desc="[B]uffer [N]ew" })
-- { "n", "<leader>fn", "<cmd>ene <bar> startinsert <cr>", "[B]uffer [N]ew" },
-- vim.keymap.set("n", "<leader>bn", ":enew<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<c-k>", "<Esc>:bnext<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<c-j>", "<Esc>:bprevious<CR>", { noremap = true, silent = true })
-- Store the last closed buffer's file path
vim.api.nvim_create_autocmd("BufDelete", {
    callback = function(event)
        local bufname = vim.api.nvim_buf_get_name(event.buf)
        if bufname ~= "" then -- Ensure the buffer has a valid file path
            vim.g.last_closed_buffer = bufname
        end
    end,
})
-- Function to reopen the last closed buffer
function ReopenLastBuffer()
    if vim.g.last_closed_buffer and vim.fn.filereadable(vim.g.last_closed_buffer) == 1 then
        vim.cmd("badd " .. vim.fn.fnameescape(vim.g.last_closed_buffer))
        vim.cmd("b " .. vim.fn.fnameescape(vim.g.last_closed_buffer))
    else
        -- print("No recently closed buffer or file does not exist")
        vim.notify("No recently closed buffer or file does not exist")
    end
end
-- vim.keymap.set("n", "<c-'>", ":lua ReopenLastBuffer()<CR>", { noremap = true, silent = true, desc = '[L]ast [B]uffer' })
vim.keymap.set("n", "<leader>bl", ":lua ReopenLastBuffer()<CR>", { noremap = true, silent = true, desc = '[L]ast [B]uffer' })
vim.keymap.set("n", "<c-t>", ":lua ReopenLastBuffer()<CR>", { noremap = true, silent = true, desc = '[L]ast [B]uffer' })
vim.keymap.set("n", "<c-t>", ":lua ReopenLastBuffer()<CR>", { noremap = true, silent = true, desc = '[L]ast [B]uffer' })
vim.keymap.set("n", "<leader>bx", ":!chmod +x %<CR>", {desc = "chmod +x"})
-- keyset('n', '-', function()
--   local cur_file = vim.fn.expand('%:t')
--   vim.cmd.Ex()
--   vim.fn.search('^' .. cur_file .. '$')
-- end, {desc = 'Open Netrw'})
-- keyset('n', '<C-c>', vim.cmd.Rex, {desc = 'Open last visited file'})
