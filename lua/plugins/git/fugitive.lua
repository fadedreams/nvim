return {
  "tpope/vim-fugitive",
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  config = function()
    -- Existing Git remaps
    -- vim.keymap.set("n", "<leader>gs", ":G<CR>", { desc = "Git status" })
    vim.keymap.set("n", "<leader>gf", ":top Git<CR>", {desc = "Fugitive: Open git console"})
    vim.keymap.set("n", "<leader>ga", ":G add %<CR>", { desc = "Git add current file" })
    vim.keymap.set("n", "<leader>gA", ":G add .<CR>", { desc = "Git add all files" })
    vim.keymap.set("n", "<leader>gc", ":G commit --no-verify<CR>", { desc = "Git commit" })

    vim.keymap.set("n", "<leader>grb", ":G checkout HEAD -- %<CR>", { desc = "Git reset current buffer to HEAD" })
    vim.keymap.set("n", "<leader>gl", ":G log --oneline --graph --all<CR>", { desc = "Git history graph" })
    vim.keymap.set("n", "<leader>gF", ":G fetch<CR>", { desc = "Git fetch" })

    vim.keymap.set("n", "<leader>gbb", ":G blame<CR>", { desc = "Git blame" })
    vim.keymap.set("n", "<leader>grh", ":G reset --hard<CR>", { desc = "Git reset hard" })
    vim.keymap.set("n", "<leader>grs", ":G reset --soft HEAD^<CR>", { desc = "Git undo last commit (soft)" })
    vim.keymap.set("n", "<leader>gm", ":G merge<CR>", { desc = "Git merge" })
    vim.keymap.set("n", "<leader>grb", ":G rebase -i<CR>", { desc = "Git interactive rebase" })
    vim.keymap.set("n", "<leader>gh", ":Gclog %<CR>", { desc = "Git history" })

    local function pre_commit_check()
      local cmd = "pre-commit"
      vim.cmd "belowright vsplit"
      vim.cmd("terminal " .. cmd)
    end
    vim.keymap.set("n", "<leader>gv", pre_commit_check, { desc = "Git verify" })

    -- vim.keymap.set("n", "<leader>gl", ":G log<CR>", { desc = "Git log" })
    -- vim.keymap.set("n", "<leader>gp", ":G push origin HEAD<CR>", { desc = "Git push" })
    -- vim.keymap.set("n", "<leader>gF", ":G pull<CR>", { desc = "Git pull" })
    -- vim.keymap.set("n", "<leader>gfP", ":G pull --rebase<CR>", { desc = "Git pull with rebase" })
    -- vim.keymap.set("n", "<leader>gdd", ":G diff<CR>", { desc = "Git diff" })
    -- vim.keymap.set("n", "<leader>gS", ":G stash<CR>", { desc = "Git stash" })
    -- vim.keymap.set("n", "<leader>gdr", ":G diff @{u} HEAD<CR>", { desc = "Git diff remote vs local" })
    -- vim.keymap.set("n", "<leader>gds", ":Gvdiffsplit<CR>", { desc = "Git diff vertical split" })
    -- vim.keymap.set("n", "<leader>gbn", ":G checkout -b ", { desc = "Git create and checkout branch" })
    -- vim.keymap.set("n", "<leader>gbc", ":G checkout ", { desc = "Git checkout branch" })
    -- vim.keymap.set("n", "<leader>gbl", ":G branch -l<CR>", { desc = "Git list branches" })

    -- Suggested additional keymaps
    -- vim.keymap.set("n", "<leader>gst", ":G stash list<CR>", { desc = "Git stash list" })
    -- vim.keymap.set("n", "<leader>gsp", ":G stash pop<CR>", { desc = "Git stash pop" })
    -- vim.keymap.set("n", "<leader>gps", ":G push --set-upstream origin ", { desc = "Git push set upstream" })

    -- Updated keybinding to populate quickfix with changed, staged, and untracked files
    vim.keymap.set("n", "<leader>gx", function()
      -- Clear the quickfix list
      vim.cmd("cexpr []")
      -- Run `git status --porcelain` to get changed and untracked files/directories
      local status_lines = vim.fn.systemlist("git status --porcelain")
      if vim.v.shell_error ~= 0 then
        print("Error running git status --porcelain")
        return
      end
      -- Log the raw git status output for debugging
      print("git status --porcelain output: " .. vim.inspect(status_lines))
      -- Convert to quickfix entries
      local qf_entries = {}
      local seen_files = {} -- To avoid duplicates
      for _, line in ipairs(status_lines) do
        -- Handle leading whitespace in status (e.g., " M d/f1")
        local status, path = line:match("^%s*(%S+)%s+(.+)$")
        if not status or not path then
          print("Skipping invalid line: " .. line)
          goto continue
        end
        -- Log the parsed status and path
        print("Processing: status=" .. status .. ", path=" .. path)
        -- Check if the path is a directory
        local is_dir = vim.fn.isdirectory(path) == 1
        print("is_dir(" .. path .. ") = " .. tostring(is_dir))
        if is_dir and status == "??" then
          -- For untracked directories, get all files within using `git ls-files`
          local files = vim.fn.systemlist("git ls-files --others --exclude-standard " .. vim.fn.shellescape(path))
          print("Untracked dir " .. path .. " contains: " .. vim.inspect(files))
          for _, file in ipairs(files) do
            if not seen_files[file] then
              table.insert(qf_entries, { filename = file, lnum = 1, col = 1, text = "Git untracked" })
              seen_files[file] = true
            end
          end
        elseif not is_dir then
          -- For non-directory files (modified/staged/untracked), add directly
          if not seen_files[path] then
            local status_text = ({
              ["??"] = "untracked",
              ["M "] = "modified (uncommitted)",
              ["MM"] = "staged and modified",
              ["A "] = "added",
              ["AM"] = "added and modified",
              ["D "] = "deleted",
            })[status] or "changed"
            table.insert(qf_entries, { filename = path, lnum = 1, col = 1, text = "Git " .. status_text })
            seen_files[path] = true
          end
        end
        ::continue::
      end
      -- Log the final quickfix entries
      -- print("Quickfix entries: " .. vim.inspect(qf_entries))
      -- Populate quickfix list
      vim.fn.setqflist(qf_entries, "r")
      -- Open the quickfix window
      vim.cmd("copen")
    end, { desc = "fill qf with Git changes&untracked files" })
  end,
}
