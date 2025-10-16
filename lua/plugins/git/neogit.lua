return {
  -- Other plugins here...

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Already in LazyVim, but good to list
      "sindrets/diffview.nvim", -- Optional: For better diff popups
    },
    cmd = "Neogit",  -- Load on command to keep startup fast
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Open Neogit" },  -- Optional: Keymap (use your leader key)
    },
    opts = {
      integrations = {
        diffview = true,  -- Enable diffview.nvim integration for side-by-side diffs
      },
      commit_editor = {
        kind = "tab",  -- Open commit editor in a new tab
        show_staged_diff = true,  -- Show staged diff in commit editor
        staged_diff_split_kind = "auto",  -- Auto-select split or vsplit for staged diff
      },
    },
  },

  -- Other plugins here...
}
