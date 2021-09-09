--- Functional-style library
local fnl = {}

local syntax = require "syntax"

--- Filters the table by ipairs & predicate
fnl.filter = syntax.pipe() .. syntax.implicit_lambda(2, "ix, it") ..
function(t, predicate)
  local result = {}
  for i, v in ipairs(t) do
    if predicate(i, v) then
      table.insert(result, v)
    end
  end
  return result
end

--- Maps the table by ipairs & function
fnl.map = syntax.pipe() .. syntax.implicit_lambda(2, "ix, it") ..
function(t, f)
  local result = {}
  for ix, it in ipairs(t) do
    table.insert(result, f(ix, it))
  end
  return result
end

--- Checks by ipairs whether all values in sequence are truthy
-- If f is given pre-maps table by f
fnl.all = syntax.pipe() ..
function(t, predicate)
  if predicate ~= nil then
    t = t / fnl.map(predicate)
  end

  for _, it in ipairs(t) do
    if not it then
      return false
    end
  end
  return true
end

--- Separates the table by ipairs & given separator
fnl.separate = syntax.pipe() ..
function(t, separator)
  if #t == 0 then return {} end

  local result = {t[1]}
  for i = 2, #t do
    table.insert(result, separator)
    table.insert(result, t[i])
  end
  return result
end

--- Folds the table by given predicate or metamethod
fnl.fold = syntax.pipe() .. function(t, f)
  if #t == 0 then return end
  local result = t[1]

  if f == nil then
    f = function(a, b) return a .. b end
  elseif type(f) == "string" then
    f = getmetatable(result)[f]
  end

  for i = 2, #t do
    result = f(result, t[i])
  end
  return result
end

-- TODO optimization: pipe + ipairs
--- Slices the table by ipairs
fnl.slice = syntax.pipe() .. function(t, first, last, step)
  if last and last < 0 then
    last = #t + last + 1
  end

  local result = {}
  for i = first or 1, last or #t, step or 1 do
    table.insert(result, t[i])
  end
  return result
end

--- Returns pretty string representation of the value
fnl.inspect = syntax.pipe() .. require "inspect"

--- Piped unpack, does not work in 5.1
fnl.unpack = syntax.pipe() .. table.unpack

--- Gets all the values by pairs & puts them into the sequence
fnl.values = syntax.pipe() .. function(t)
  result = {}
  for _, v in pairs(t) do
    table.insert(result, v)
  end
  return result
end

--- Mutates the given table by removing the value
fnl.remove = function(t, value)
  for i, v in ipairs(t) do
    if v == value then
      table.remove(t, i)
      return value
    end
  end
end

--- Copies & extends one table by another
fnl.extend = syntax.pipe() .. function(table1, table2)
  result = table1 / fnl.copy()
  for k, v in pairs(table2) do
    result[k] = v
  end
  return result
end

--- Creates a copy of the given table
fnl.copy = nil
fnl.copy = syntax.pipe() .. function(t, cache, not_deep)
  if t == nil then return nil end

  if type(t) ~= "table" then return t end
  if not cache then cache = {} end
  if cache[t] then return cache[t] end

  if t.copy ~= nil then
    return t:copy()
  end

  local result = {}

  setmetatable(result, getmetatable(t))
  cache[t] = result

  for k, v in pairs(t) do
    if not_deep or type(v) ~= "table" then
      result[k] = v
    else
      result[k] = v / fnl.copy(cache)
    end
  end
  return result
end

--- Is it useful?
fnl.inherit = syntax.pipe() .. function(child, parent)
  setmetatable(child, parent)
  parent.__index = parent
  return child
end

--- Checks by ipairs whether the table contains the given value
fnl.contains = syntax.pipe() .. function(collection, element)
  return #(collection / fnl.filter(function(ix, it) return it == element end)) > 0
end

return fnl
