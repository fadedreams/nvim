
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  event = "VeryLazy", -- Optional: Lazy-load on events to improve startup time
  config = function()
    local actions = require("diffview.actions")
    local diffview_config = require("diffview.config")
    -- Optional: Configure diffview.nvim settings
    require("diffview").setup({
      keymaps = {
        view = {
          ["q"] = "<Cmd>DiffviewClose<CR>", -- Map 'q' to close Diffview
          ["co"] = actions.conflict_choose_all("ours"), -- Choose conflict --ours
          ["ct"] = actions.conflict_choose_all("theirs"), -- Choose conflict --theirs
          ["cb"] = actions.conflict_choose_all("base"), -- Choose conflict --base
        },
        file_panel = {
          ["<c-j>"] = false,
          ["<c-k>"] = false,
          {
            "n",
            "<c-j>",
            diffview_config.actions.scroll_view(0.25),
            {desc = "Diffview: Scroll the view down"},
          },
          {
            "n",
            "<c-k>",
            diffview_config.actions.scroll_view(-0.25),
            {desc = "Diffview: Scroll the view up"},
          },
          ["q"] = "<Cmd>DiffviewClose<CR>", -- Map 'q' to close Diffview in file panel
          ["co"] = actions.conflict_choose_all("ours"), -- Choose conflict --ours
          ["ct"] = actions.conflict_choose_all("theirs"), -- Choose conflict --theirs
          ["cb"] = actions.conflict_choose_all("base"), -- Choose conflict --base
        },
        file_history_panel = {
          ["q"] = "<Cmd>DiffviewClose<CR>", -- Map 'q' to close Diffview in file history panel
          ["co"] = actions.conflict_choose_all("ours"), -- Choose conflict --ours
          ["ct"] = actions.conflict_choose_all("theirs"), -- Choose conflict --theirs
          ["cb"] = actions.conflict_choose_all("base"), -- Choose conflict --base
        },
      },
    })
    -- Map <leader>dv to open Diffview
    vim.keymap.set("n", "<leader>dh", "<Cmd>DiffviewFileHistory<CR>", { noremap = true, silent = true, desc = "Git diff history" })
    vim.keymap.set("n", "<leader>dl", "<Cmd>DiffviewOpen<CR>", { noremap = true, silent = true, desc = "Git diff local" })
    vim.keymap.set("n", "<leader>dr", "<Cmd>DiffviewOpen @{u}..HEAD<CR>", { noremap = true, silent = true, desc = "Git diff remote vs local" })
    vim.keymap.set("n", "<leader>dd", "<Cmd>DiffviewFileHistory %<CR>", { noremap = true, silent = true, desc = "Git diff history for current buffer" })
  end,
}
