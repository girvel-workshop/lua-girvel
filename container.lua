local yaml = require "yaml"
local fnl = require "fnl"

local container = {}

container.file =
	fnl.docs{
		type='function',
		description='creates a table to read & write a file'
	} ..
	function(path)
		local folder_path = path / "/"
			/ fnl.slice(1, -2)
			/ fnl.separate("/")
			/ fnl.join() or "."

		return {
			path=path,
			folder_path=folder_path,
			get=function(self)
				local file = io.open(self.path, "r")

				if not file then
					exception.throw{message="file %s does not exist" % self.path}
				end
				
				local result = file:read("*a")
				file:close()
				return result
			end,
			set=function(self, content)
				print(mkdir("-p " .. self.folder_path))
				local file = io.open(self.path, "w")
				file:write(content)
				file:close()
			end
		}
	end
	
container.yaml = 
	fnl.docs{
		type='function',
		description='creates a table to read & write to yaml file',
		args={'path to the file'}
	} ..
	function(path)
		local file_container = container.file(path)

		file_container.get_yaml = function(self)
			return yaml.load(self:get())
		end

		file_container.set_yaml = function(self, t)
			self:set(yaml.dump{t}:sub(5, -5))
		end
	
		return setmetatable(file_container, {
			__index=function(self, index)
				return self:get_yaml()[index]
			end,
			__newindex=function(self, index, value)
				local content = self:get_yaml()
				content[index] = value
				self:set_yaml(content)
			end
		})
	end

-- TODO as decorator
-- TODO decorator is a decorator
container.property =  
	fnl.docs{} ..
	function(t)
		-- TODO tk.copy(t, true)
		return setmetatable(t, {
			__index=function(self, index)
				return self["get_" .. index](self)
			end,
			__newindex=function(self, index, value)
				return self["set_" .. index](self, value)
			end
		})
	end

return container
