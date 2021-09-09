--- Toolkit module, containing all the unclassified functionality
local tk = {}

local fnl = require "fnl"

local string = string or getmetatable('').__index

--- Converts lua path to posix format
function string:to_posix()
  local str = self:gsub("%.", "/")
  return str
end

--- Creates a tree: the table, who creates subtables when __index
function tk.tree()
  return setmetatable({}, {
    __index=function(self, index)
      self[index] = tk.tree()
      return self[index]
    end
  })
end

return tk
