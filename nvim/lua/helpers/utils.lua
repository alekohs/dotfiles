local M = {}

-- Use ssh for lazy.nvim
M.lazy_use_ssh = vim.fn.getenv("NVIM_PLUGINS_SSH") == "1"

--- Combine two or more tables
--- @return table table Combine mulitple tables
function M.combine_tables(...)
    local combined = {}
    for _, tbl in ipairs({...}) do
        for _, value in ipairs(tbl) do
            table.insert(combined, value)
        end
    end
    return combined
end

--- Get packages path
---@param packages table A table with all packages name
---@param separator string Separator to be checked, if nil it uses default for os
---@param trim_end string If path ends with given string, remove it
---@return table Returns a table with packages paths, example { roslyn = "/abc/roslyn/bin" }
function M.get_packages_path(packages, separator, trim_end)
  trim_end = trim_end or nil
  -- Get the PATH environment variable
  local path_env = vim.fn.getenv("PATH") or ""

  -- Split the PATH into individual paths
  separator = separator or package.config:sub(1, 1)
  local paths = vim.split(path_env, separator, { trimempty = true })

  -- Find paths containing the search terms
  local matching_paths = {}
  for _, path in ipairs(paths) do
    if trim_end and path:sub(-#trim_end) == trim_end then
      path = path:sub(1, -#trim_end - 1)
    end

    for _, name in ipairs(packages) do
      if string.find(path, name, 1, true) then
        matching_paths[name] = path
        break
      end
    end
  end

  return matching_paths
end

--- Get root path
function M.root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+$", "") -- remove trailing newline
  end
end

return M
