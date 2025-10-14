return {
  "tpope/vim-fugitive",
  -- event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- Existing Git remaps
    -- vim.keymap.set("n", "<leader>gs", ":G<CR>", { desc = "Git status" })
    vim.keymap.set("n", "<leader>gf", ":top Git<CR>", { desc = "Fugitive: Open git console" })
    vim.keymap.set("n", "<leader>ga", ":silent G add %<CR>", { desc = "Git add current file" })
    vim.keymap.set("n", "<leader>gA", ":silent G add .<CR>", { desc = "Git add all files" })
    vim.keymap.set("n", "<leader>gc", ":silent G commit --no-verify<CR>", { desc = "Git commit" })
    vim.keymap.set("n", "<leader>grb", ":silent G checkout HEAD -- %<CR>", { desc = "Git reset current buffer to HEAD" })
    vim.keymap.set("n", "<leader>gl", ":silent G log --oneline --graph --all<CR>", { desc = "Git history graph" })
    vim.keymap.set("n", "<leader>gF", ":silent G fetch<CR>", { desc = "Git fetch" })
    vim.keymap.set("n", "<leader>gbb", ":silent G blame<CR>", { desc = "Git blame" })
    vim.keymap.set("n", "<leader>grh", ":silent G reset --hard<CR>", { desc = "Git reset hard" })
    vim.keymap.set("n", "<leader>grs", ":silent G reset --soft HEAD^<CR>", { desc = "Git undo last commit (soft)" })
    vim.keymap.set("n", "<leader>gm", ":silent G merge<CR>", { desc = "Git merge" })
    vim.keymap.set("n", "<leader>gre", ":silent G rebase -i<CR>", { desc = "Git interactive rebase" })
    vim.keymap.set("n", "<leader>gh", ":silent Gclog %<CR>", { desc = "Git history" })
    vim.keymap.set("n", "<leader>gv", ":silent Gvdiffsplit<CR>", { desc = "Git diff vertical split" })
    vim.keymap.set("n", "<leader>gs", ":silent Gdiffsplit<CR>", { desc = "Git diff horizontal split" })
    local function pre_commit_check()
      local cmd = "pre-commit"
      vim.cmd "belowright vsplit"
      vim.cmd("terminal " .. cmd)
    end
    vim.keymap.set("n", "<leader>gp", pre_commit_check, { desc = "Git verify" })
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
  -- Run git status --porcelain to get changed and untracked files/directories
  local status_lines = vim.fn.systemlist("git status --porcelain")
  if vim.v.shell_error ~= 0 then
    print("Error running git status --porcelain")
    return
  end
  if #status_lines == 0 then
    print("No Git changes found")
    return
  end
  -- Convert to quickfix entries
  local qf_entries = {}
  local seen_files = {} -- To avoid duplicates
  local status_map = {
    ["??"] = "untracked",
    ["M"] = "modified (uncommitted)",
    ["MM"] = "staged and modified",
    ["A"] = "added",
    ["AM"] = "added and modified",
    ["D"] = "deleted",
    ["R"] = "renamed",
    ["C"] = "copied",
    ["U"] = "updated but unmerged",
  }
  for _, line in ipairs(status_lines) do
    -- Handle renamed files
    local status, old_path, new_path = line:match("^%s*R%s+(.+)%s+->%s+(.+)$")
    if status and old_path and new_path then
      if not seen_files[new_path] then
        table.insert(qf_entries, { filename = new_path, lnum = 1, col = 1, text = "Git renamed" })
        seen_files[new_path] = true
      end
      goto continue
    end
    -- Handle other statuses
    status, path = line:match("^%s*(%S+)%s+(.+)$")
    if not status or not path then
      goto continue
    end
    -- Check if the path is a directory
    local is_dir = vim.fn.isdirectory(path) == 1
    if is_dir and status == "??" then
      -- For untracked directories, get all files within using git ls-files
      local files = vim.fn.systemlist("git ls-files --others --exclude-standard " .. vim.fn.shellescape(path))
      if vim.v.shell_error ~= 0 then
        print("Error listing files in directory: " .. path)
        goto continue
      end
      for _, file in ipairs(files) do
        if not seen_files[file] then
          table.insert(qf_entries, { filename = file, lnum = 1, col = 1, text = "Git untracked" })
          seen_files[file] = true
        end
      end
    elseif not is_dir then
      -- For non-directory files, add directly
      if not seen_files[path] then
        local status_text = status_map[status] or "changed"
        table.insert(qf_entries, { filename = path, lnum = 1, col = 1, text = "Git " .. status_text })
        seen_files[path] = true
      end
    end
    ::continue::
  end
  -- Populate quickfix list
  vim.fn.setqflist(qf_entries, "r")
  -- Open the quickfix window with a specific height
  vim.cmd("copen 10")
end, { desc = "Fill quickfix with Git changed files" })
  end,
}
