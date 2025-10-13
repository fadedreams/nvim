return {
  "mbbill/undotree",
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  keys = {
    { "<leader>ut", ":UndotreeToggle<CR>", desc = "[U]ndo [T]ree" },
  },
}
