local tk = require "tk"
local exception = require "exception"
require "strong"

local module = {}

local function is_directory(path)
	return io.open(path) and not io.open(path, "a")
end

local function is_file(path)
	return io.open(path) and io.open(path, "a")
end

module.default_represent = {
	repr = function(path)
		return require(path:gsub(".lua", ""):gsub("/", "."))
	end,
	extension = "lua"
}

function module:new(path)
	return setmetatable({path = path}, {
		__index = function(self, item)
  		return module:new(self.path .. "." .. item)
		end,
		__unm = function(self)
			local represent = module.get_represent_for_path(self.path)
			if not io.open(self.path:to_posix() .. "." .. represent.extension) 
				and not io.open(self.path:to_posix()) then
				error(exception{
					message="Module %s does not exist" % self.path,
					type="module_does_not_exist"
				})
			end

			if is_file(self.path:to_posix() .. "." .. represent.extension) then
				return module.require(self.path)
			end
		
		  return module.require_all(self.path)
		end,
		__call = function(self)
			return -self
		end
	})
end

module.require_all = tk.cache() .. function(luapath)
  if not io.open(luapath:to_posix()) then return end
  
  local result = {}

  local represent = module.get_represent_for_path(luapath)
  
  for _, file in ipairs(love.filesystem.getDirectoryItems(luapath:to_posix())) do
  	if not file:startsWith("_") then
  		local value
  		if file:endsWith("." .. represent.extension) then
        file = file:gsub("%.[%w%d]*", "")
        value = module.require(luapath .. "." .. file)
  		elseif is_directory(luapath:to_posix() .. "/" .. file, 'file') then
  			value = module.require_all(luapath .. "." .. file)
  		end
  		result[file] = value
  	end
  end

  return result
end

module.require = tk.cache() .. function(luapath)
  local represent = module.get_represent_for_path(luapath)
  return represent.repr(luapath:to_posix() .. "." .. represent.extension)
end

function module.get_represent_for_path(luapath)
  local path = ""
  local represent = module.default_represent

  for i, element in ipairs(luapath / ".") do
    path = i == 1 and element or (path .. "." .. element)
    
    represent = is_file(path:to_posix() .. "/_representation.lua") 
      and require(path .. "._representation")
       or represent
  end

  return represent
end

return module
