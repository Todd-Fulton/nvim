local M = {}

local function is_windows_os()
  return package.config:sub(1, 1) == '\\'
end

local function get_path_separator()
  if is_windows_os() then
    return '\\'
  end
  return '/'
end


function M.script_path()
  local str = debug.getinfo(2, 'S').source:sub(2)
  if is_windows_os() then
    str = str:gsub('/', '\\')
  end
  return str:match('(.*' .. get_path_separator() .. ')')
end


return M
