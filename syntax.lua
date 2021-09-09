--- Library containing all the syntax changing functions
local syntax = {}

local environment = require "environment"
environment.fix()
require "strong"

local decorator = function(f)
  return setmetatable({function_=f},{
    __call = function(called, ...)
      return setmetatable({function_= called.function_, args = {...}}, {
        __concat = function(concatenated, value)
          return concatenated:function_(value, unpack(concatenated.args))
        end
      })
    end
  })
end

--- Creates a decorator from the given function
-- @param f base function(decorator, decorated, decoration_args...)
syntax.decorator = decorator(function(_, f)
  return decorator(f)
end)

--- Decorator making the function f(x, ...) a piped one with syntax x / f(...)
syntax.pipe = syntax.decorator() .. function(_, f)
  return setmetatable({base_function=f}, {__call = function(called, ...)
    return setmetatable({base_function=called.base_function, args={...}}, {
      __div = function(x, divided)
        return f(x, table.unpack(divided.args))
      end
    })
  end})
end

--- Dynamically creates a function from lambda-string <args> -> <result>
-- @param source lambda source code
syntax.lambda = function(source)
  environment.push(_ENV or getfenv())

  local a, b = source:find(" %-> ")
  local args = source:sub(0, a - 1)
  local result = source:sub(b + 1)

  local function_text = "function(%s) return %s end" % {args, result}
  local loading_function, err = (loadstring or load)("return " .. function_text)

  if loading_function == nil then
    error(err)
  end

  return loading_function()
end

--- Decorator, making Nth argument an implicit lambda
-- If the Nth argument to the decorated function is a string, it is automatically
-- parsed to be an implicit lambda with given arguments
syntax.implicit_lambda = syntax.decorator() ..
function(_, f, argument_index, args_definition)
  return function(...)
    local args = {...}
    if type(args[argument_index]) == "string" then
      args[argument_index] = syntax.lambda(
        args_definition .. " -> " .. args[argument_index]
      )
    end

    return f(unpack(args))
  end
end

return syntax