local unpack = table.unpack
require "strong"
local exception = require "exception"
local environment = require "environment"


return function(text)
  environment.push(_ENV or getfenv())

  local a, b = text:find(" %-> ")
  local args = text:sub(0, a - 1)
  local result = text:sub(b + 1)  
  
  local function_text = "function(%s) return %s end" % {args, result}
  local loading_function, err = (loadstring or load)("return " .. function_text)
  
  if loading_function == nil then
    error(err)
  end
  
  return loading_function()
end
