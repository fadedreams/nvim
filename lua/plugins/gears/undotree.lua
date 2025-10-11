return {
  "mbbill/undotree",
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  keys = {
    { "<leader>uu", ":UndotreeToggle<CR>", desc = "Toggle Undotree" },
  },
}
