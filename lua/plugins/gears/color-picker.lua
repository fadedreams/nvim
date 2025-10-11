return {
  {
    "ziontee113/color-picker.nvim",
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    config = function()
      require("color-picker").setup({
        -- ["icons"] = { "ﱢ", "" }, -- Customize icons if needed
        -- ["icons"] = { "o", "e" }, -- Replace with Unicode values of your chosen icons
        -- ["icons"] = { "\u{f0c8}", "\u{f040}" }, -- Square and Pencil icons
        ["icons"] = { "o", "\u{f040}" }, -- Square and Pencil icons

        ["border"] = "rounded", -- Set border style
        ["keymap"] = {
          ["a"] = "<Plug>ColorPickerSlider5Increase",
          ["x"] = "<Plug>ColorPickerSlider5Decrease",
        },
      })

      -- Customize highlight groups if desired
      vim.cmd([[hi FloatBorder guibg=NONE]])
    end,
    cmd = { "PickColor", "PickColorInsert" }, -- Load when using these commands
    keys = {
      { "<leader>up", "<cmd>PickColor<cr>", mode = "n", noremap = true, silent = true, desc="[U]tils [P]aint" },
      -- { "<leader>fci", "<cmd>PickColorInsert<cr>", mode = "i", noremap = true, silent = true }, -- Insert mode keymap for PickColorInsert
      -- { "<leader>tc", "<cmd>PickColorInsert<cr>", mode = "i", noremap = true, silent = true },
    },
  },
}
