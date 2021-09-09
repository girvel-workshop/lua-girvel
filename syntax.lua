--- Library containing all the syntax changing functions

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

return syntax