local modpath = (...)

local M = {}

for filename in io.popen('ls -pUqAL '.. modpath):lines() do
   filename = filename:match"^(.*)%.lua$"
   if filename and filename ~= "init" then
      M[filename] = require(modpath .. "." .. filename)
   end
end

return M
