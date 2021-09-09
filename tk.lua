local decorator = require "decorator"
local fnl = require "fnl"

local tk = {}

local string = string or getmetatable('').__index
function string:to_posix()
  local str = self:gsub("%.", "/")
  return str
end

return tk
