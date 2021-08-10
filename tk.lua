local decorator = require "decorator"
local fnl = require "fnl"

local tk = {}

tk.cache = decorator:new(function(self, f) 
  return function(argument)
    if not self.global_cache[f] then
      self.global_cache[f] = {}
    end

    if not self.global_cache[f][argument] then
      self.global_cache[f][argument] = f(argument)
    end
    
    return self.global_cache[f][argument]
  end
end)

tk.cache.global_cache = {}

tk.set =
	fnl.docs{
		type='pipe function',
		description='transforms the sequence to a set'
	} ..
	fnl.pipe() ..
	function(t)
		local result = {}
		for _, v in ipairs(t) do
			result[v] = true
		end
		return result
	end

local string = string or getmetatable('').__index
function string:to_posix()
  local str = self:gsub("%.", "/")
  return str
end

return tk
