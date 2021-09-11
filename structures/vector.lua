--- Library structure to work with N-dimensional vectors
local vector = {}
local module_mt = {}
setmetatable(vector, module_mt)

local vector_methods = {}
local vector_mt = {
  --- Allows to get v[1], v[2], ... as v.x, v.y, ...
  __index=function(self, index)
    return rawget(self, self.dimensions[index]) or vector_methods[index]
  end
}

local fnl = require 'fnl'


--- Creates vector w/ varargs
module_mt.__call = function(self, ...)
  return setmetatable({
    dimensions={
      x=1,
      y=2,
      z=3,
      w=4
    },
    ...
  }, vector_mt)
end

--- Calculates vector's squared magnitude
vector_methods.squared_magnitude = function(self)
  return self / fnl.map(function(ix, it) return it^2 end) / fnl.fold "+"
end

return vector

-- [[ OBSOLETE CODE ]]

--[[
function vector:new(x, y)
  local v={x=x, y=y}
  setmetatable(v, self)
  self.__index = self
  return v
end

function vector:magnitude()
  return (self.x ^ 2 + self.y ^ 2) ^ .5
end

function vector:rotated(angle)
  return vector:new(
    math.cos(angle) * self.x - math.sin(angle) * self.y,
    math.sin(angle) * self.x + math.cos(angle) * self.y
  )
end

function vector:unpack()
  return self.x, self.y
end

function vector.__unm(v)
  return v * -1
end

function vector.__add(v, u)
  return vector:new(v.x + u.x, v.y + u.y)
end

function vector.__sub(v, u)
  return v + -u
end

function vector.__mul(v, k)
  return vector:new(v.x * k, v.y * k)
end

function vector.__div(v, k)
  return v * (1 / k)
end

function vector.zero()
  return vector:new(0, 0)
end

function vector.right()
  return vector:new(1, 0)
end

function vector.left()
  return vector:new(-1, 0)
end

function vector.up()
  return vector:new(0, -1)
end

function vector.one()
  return vector:new(1, 1)
end

return vector

]]