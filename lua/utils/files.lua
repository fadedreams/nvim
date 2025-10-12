local M = {}

---Read file content.
---@param fpath string Absolute file path.
---@return string? # File content.
function M.read_file(fpath)
    if vim.fn.filereadable(fpath) == 0 then
        error('File "' .. fpath .. '" does not exist or is not readable')
    end

    local fd = assert(vim.uv.fs_open(fpath, 'r', 420), 'Reading file failed')
    local stat = assert(vim.uv.fs_fstat(fd), 'Reading file content failed')
    local cont = vim.uv.fs_read(fd, stat.size)
    vim.uv.fs_close(fd)

    return cont
end

---Read and decode file into JSON data.
---@param fpath string JSON file path.
---@return any # Decoded JSON data.
function M.load_json_file(fpath)
    local cont = M.read_file(fpath)
    if not cont then
        error('Could not load JSON file "' .. fpath .. '"')
    end
    return vim.json.decode(cont, { luanil = { object = true, array = true } })
end

---Get real base directory for the current buffer.
---
---@return string # Real absolute directory path.
function M.buf_get_real_base()
    local bufname = vim.api.nvim_buf_get_name(0)
    local realpath = vim.uv.fs_realpath(bufname)
    local cwd

    if bufname == '' then -- [No Name]
        cwd = vim.uv.cwd() or vim.fn.getcwd()
    elseif not realpath then -- new file
        cwd = vim.fs.dirname(bufname)
    else
        cwd = vim.fs.dirname(realpath) -- currrent file or symlink
    end

    return cwd
end

return M
