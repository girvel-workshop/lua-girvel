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

--- Gets a custom tree path
function tk.get(tree_, head, ...)
  if head == nil then
    return tree_
  end

  return tk.get(tree_[head], ...)
end

--- Sets a value of the tree by a variadic path
function tk.set(tree_, value, head, ...)
  if #{...} == 0 then
    tree_[head] = value
    return
  end

  return tk.set(tree_[head], value,...)
end

return tk
