--- Library structure to work with values locked in the predefined range
local limited = {}
local module_mt = {}
setmetatable(limited, module_mt)

local limited_mt = {__index = {}}

--- Creates limited value
module_mt.__call = function(value, min, max) 
  return setmetatable({
    value=value,
    min= min,
    to= max
  }, limited_mt)
end

--- Creates limited value set to minimal (default is 0)
limited.minimized = function(to, value, min) 
  return limited(value or min or 0, min or 0, to)
end

--- Creates limited value set to maximal
limited.maximized = function(to, value, min) 
  return limited(value or to, min or 0, to)
end

--- Try to move value and return success
limited_mt.__index.move = function(self, delta)
  if delta < 0 then
    if self.value > 0 then
      self.value = math.max(self.min, self.value + delta)
      return true
    end

    return false
  else
    if self.value < self.limit then
      self.value = math.min(self.to, self.value + delta)
      return true
    end

    return false
  end
end

--- Is the value minimized
limited_mt.__index.is_min = function(self)
  return self.value == self.min
end

--- Is the value maximized
limited_mt.__index.is_max = function(self)
  return self.value == self.max
end

--- Get the value in [0; 1] indicating current state of the limited value
limited_mt.__index.fraction = function(self)
  return (self.value - self.min) / (self.max - self.min)
end

return limited