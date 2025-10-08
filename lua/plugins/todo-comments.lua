
return   {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPre",
  opts = {
    gui_style = {
      fg = "NONE",
      bg = "NONE",
    },
    colors = {
      info = {"DiffText", "#2563EB"},
    },
  },
  cmd = "TodoFzfLua",
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
  },
}
