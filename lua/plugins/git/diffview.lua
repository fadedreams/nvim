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
  event = "VeryLazy",
  config = function()
    local actions = require("diffview.actions")
    local diffview_config = require("diffview.config")
    require("diffview").setup({
      keymaps = {
        view = {
          ["q"] = "<Cmd>DiffviewClose<CR>",
          ["co"] = actions.conflict_choose_all("ours"),
          ["ct"] = actions.conflict_choose_all("theirs"),
          ["cb"] = actions.conflict_choose_all("base"),
        },
        file_panel = {
          ["<c-j>"] = false,
          ["<c-k>"] = false,
          {
            "n",
            "<c-j>",
            diffview_config.actions.scroll_view(0.25),
            { desc = "Diffview: Scroll the view down" },
          },
          {
            "n",
            "<c-k>",
            diffview_config.actions.scroll_view(-0.25),
            { desc = "Diffview: Scroll the view up" },
          },
          ["q"] = "<Cmd>DiffviewClose<CR>",
          ["co"] = actions.conflict_choose_all("ours"),
          ["ct"] = actions.conflict_choose_all("theirs"),
          ["cb"] = actions.conflict_choose_all("base"),
        },
        file_history_panel = {
          ["q"] = "<Cmd>DiffviewClose<CR>",
          ["co"] = actions.conflict_choose_all("ours"),
          ["ct"] = actions.conflict_choose_all("theirs"),
          ["cb"] = actions.conflict_choose_all("base"),
        },
      },
    })
    vim.keymap.set("n", "<leader>dh", "<Cmd>DiffviewFileHistory<CR>", { noremap = true, silent = true, desc = "Git diff history" })
    vim.keymap.set("n", "<leader>dl", "<Cmd>DiffviewOpen<CR>", { noremap = true, silent = true, desc = "Git diff local" })
    vim.keymap.set("n", "<leader>dr", "<Cmd>DiffviewOpen @{u}..HEAD<CR>", { noremap = true, silent = true, desc = "Git diff remote vs local" })
    vim.keymap.set("n", "<leader>dd", function()
      local path = vim.fn.expand("%:p")
      if path == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
      end
      vim.notify("Attempting DiffviewFileHistory with path: " .. path, vim.log.levels.INFO)
      require("diffview").file_history(nil, { path })
    end, { noremap = true, silent = true, desc = "Git diff history for current buffer" })
  end,
}
