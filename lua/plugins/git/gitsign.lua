return{
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = function()
      local desc = Utils.plugin_keymap_desc("gitsigns")

      return {
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
      signs_staged = {},  -- Fully disable staged sign definitions (optional, but recommended)
      signs_staged_enable = false,  -- Disable staged signs (as before)
      count_chars = {},  -- Disable counts in folded regions (this hides fold signs)

        current_line_blame = true,
        current_line_blame_opts = { delay = 500 },
        preview_config = {
          border = "single",
          title = "Preview changes",
          title_pos = "center",
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function()
              gs.next_hunk()
              vim.cmd("normal! zz")
            end)
            return "<Ignore>"
          end, { expr = true, desc = desc("Next hunk") })

          map("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function()
              gs.prev_hunk()
              vim.cmd("normal! zz")
            end)
            return "<Ignore>"
          end, { expr = true, desc = desc("Previous hunk") })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = desc("Stage hunk") })
          map("n", "<leader>hr", gs.reset_hunk, { desc = desc("Reset hunk") })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = desc("Stage hunk") })

          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = desc("Reset hunk") })

          map("n", "<leader>hp", gs.preview_hunk, { desc = desc("Preview hunk") })
          map("n", "<leader>hi", gs.preview_hunk_inline, { desc = desc("Preview git hunk inline") })

          map("n", "<leader>hd", gs.diffthis, { desc = desc("gitsigns.diffthis") })

          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = desc("Blame line") })

          map("n", "<leader>ht", gs.toggle_current_line_blame, { desc = desc("Toggle current line blame") }) -- New keymap to toggle current_line_blame


          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>") -- vih, yih, dih
        end,
      }
    end,
  }
