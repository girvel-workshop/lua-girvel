--- Library containing functions to work with lua environments
local environment = {}

--- Pushes upper local variables into the current scope
environment.push = function(env, delta)
  local i = 1
  while true do
    local name, value = debug.getlocal(3 + (delta or 0), i)
    if not name then return end
    env[name] = value
    i = i + 1
  end
end

local function get_last_index(x)
  local mt = getmetatable(x)

  if mt == nil or mt.__index == nil then
    return x
  end

  return get_last_index(mt.__index)
end

--- Makes names from the given table available inside the given function
environment.append = function(env, f)
  local last_index = get_last_index(_G)

  local result
  local mt = getmetatable(last_index)
  if mt == nil then
    setmetatable(last_index, {__index=env, __newindex=env})
    result = f()
    setmetatable(last_index, nil)
  else
    old_index = mt.__index
    old_newindex = mt.__newindex

    mt.__index = env
    mt.__newindex = env

    result = f()

    mt.__index = old_index
    mt.__newindex = old_newindex
  end

  return result
end

--- Removes compatibility issues
environment.fix = function()
  table.unpack = unpack or table.unpack
  unpack = table.unpack
end

return environment
