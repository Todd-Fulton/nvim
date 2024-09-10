local modpath = (...)
local M = {}
local utils = require'utils'

for filename in io.popen('ls -pUqAL '.. utils.script_path()):lines() do
   filename = filename:match"^(.*)%.lua$"
   if filename and filename ~= "init" then
      M[filename] = require(modpath .. "." .. filename)
   end
end

return M
