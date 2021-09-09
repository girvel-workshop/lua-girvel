--- Library containing all the syntax changing functions

local environment = require "environment"
require "strong"

local syntax = {}

--- Creates a decorator from the given function
-- @param f base function(decorator, decorated, decoration_args...)
syntax.decorator = function(f)
  return setmetatable({function_=f},{
    __call = function(self, ...)
      return setmetatable({function_=self.function_, args = {...}}, {
        __concat = function(self, other)
          return self:function_(other, unpack(self.args))
        end
      })
    end
  })
end

--- Decorator making the function f(x, ...) a piped one with syntax x / f(...)
syntax.pipe = syntax.decorator(function(_, f)
  return function(...)
    return setmetatable({args={...}}, {
      __div = function(table, self)
        result = f(table, (unpack or table.unpack)(self.args))
        return result
      end
    })
  end
end)

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

return syntax