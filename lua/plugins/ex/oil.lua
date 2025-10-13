local desc = Utils.plugin_keymap_desc("oil")

return {
  "stevearc/oil.nvim",
  dependencies = {
    {"nvim-treesitter/nvim-treesitter"},
    {"nvim-tree/nvim-web-devicons", lazy = true},
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return vim.startswith(name, ".DS_Store")
      end,
    },
    keymaps = {
      ["<C-h>"] = false, -- Split
      ["<C-l>"] = false, -- refresh
      ["<C-s>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-g>"] = "actions.refresh",

      -- ["<C-h>"] = false,
      -- ["<M-h>"] = "actions.select_split",
      -- ["<M-v>"] = "actions.select_vsplit",
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-l>"] = "actions.select",
      -- ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      -- ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["q"] = { "actions.close", mode = "n" },
      ["<C-r>"] = "actions.refresh",
      -- ["-"] = { "actions.parent", mode = "n" },
      ["<BS>"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["<C-h>"] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    float = {padding = 4},
  },
  config = function(_, opts)
    local oil = require("oil")
    oil.setup(opts)
    vim.keymap.set("n", "-", oil.open, {desc = desc("Open parent directory")})

    vim.keymap.set("n", "<leader>oo", function()
      require("oil").open_float()
      -- Wait until oil has opened, for a maximum of 1 second.
      vim.wait(1000, function() return require("oil").get_cursor_entry() ~= nil end)
      if require("oil").get_cursor_entry() then
        require("oil").open_preview()
      end
    end, {desc = desc("[O]il")})

  end,
}
