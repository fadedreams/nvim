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
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = desc("Blame line") })
          map("n", "<leader>ih", gs.toggle_current_line_blame, { desc = desc("Toggle current line blame") }) -- New keymap to toggle current_line_blame

          vim.keymap.set('n', '<leader>ha', function()
            local filename = vim.fn.expand('%') -- Capture the current file's name
            if filename == '' or vim.bo.filetype == 'nofile' then
              vim.notify('No file associated with the current buffer', vim.log.levels.ERROR)
              return
            end
            vim.cmd('new') -- Open a new buffer
            vim.cmd('r !git diff HEAD -- ' .. vim.fn.shellescape(filename)) -- Run git diff with the captured filename
            vim.bo.filetype = 'diff' -- Set filetype for syntax highlighting
            vim.bo.buftype = 'nofile' -- Prevent saving the buffer
            vim.bo.bufhidden = 'wipe' -- Auto-delete when closed
          end, { desc = "Show all changes in file" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>") -- vih, yih, dih
        end,
      }
    end,
  }
