

local M = {}

-- TODO: Refactor to utils module
local function is_win()
  return package.config:sub(1, 1) == '\\'
end

local function get_path_separator()
  if is_win() then
    return '\\'
  end
  return '/'
end

local function script_path()
  local str = debug.getinfo(2, 'S').source:sub(2)
  if is_win() then
    str = str:gsub('/', '\\')
  end
  return str:match('(.*' .. get_path_separator() .. ')')
end

for filename in io.popen('ls -pUqAL '.. script_path()):lines() do
   filename = filename:match"^(.*)%.lua$"
   if filename and filename ~= "init" then
      M[filename] = require("dap-configs.configurations." .. filename)
   end
end

return M
