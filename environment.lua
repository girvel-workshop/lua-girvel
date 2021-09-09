local environment = {}

-- TODO full documentation
environment.push = function(env, delta)
  local i = 1
  while true do
    local name, value = debug.getlocal(3 + (delta or 0), i)
    if not name then return end
    env[name] = value
    i = i + 1
  end
end

-- TODO nested use
environment.use = function(env, f)
  local old_metatable = getmetatable(_G)
  setmetatable(_G, {__index=env, __newindex=env})
  f()
  setmetatable(_G, old_metatable)
end

return environment
