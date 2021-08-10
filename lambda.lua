require "strong"
local exception = require "exception"

-- TODO full documentation
local push_environment = function(env, delta)
  local i = 1
  while true do
    local name, value = debug.getlocal(3 + (delta or 0), i)
    if not name then return end
    env[name] = value
    i = i + 1
  end
end

return function(text)
	push_environment(_ENV or getfenv())

  local a, b = text:find(" %-> ")
  local args = text:sub(0, a - 1)
  local result = text:sub(b + 1)  
  
  local function_text = "function(%s) return %s end" % {args, result}
  local loading_function = load("return " .. function_text)
  
  if loading_function == nil then
    exception.throw{author = "girvel.lambda", message = "Incorrect lambda `%s`" % function_text}
    -- TODO auto author
  end
  
  return loading_function()
end
