return{
  "rmagatti/auto-session",
  lazy = false,  -- Load early for auto-restore
  config = function()
    require("auto-session").setup({
      auto_session_suppress_dirs = {'/', '~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/'},  -- Optional: skip these dirs
      auto_save_enabled = true,
      auto_restore_enabled = true,
    })

    -- Define keymaps
    local map = vim.keymap.set
    map("n", "<Leader>sas", "<Cmd>SessionSave<CR>", { desc = "Save session" })
    map("n", "<Leader>sal", "<Cmd>SessionRestore<CR>", { desc = "Restore session" })
  end,
}
