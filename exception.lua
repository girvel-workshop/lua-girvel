local exception = {}

-- TODO docs
-- TODO todos -> crater stat
setmetatable(exception, {__call=function(self, ex)
	ex.author = debug.getinfo(2).name or "anonymous function"
	return setmetatable(ex, {__tostring = function(self) 
		return "[" .. self.author .. "] " .. self.message 
	end})
end})

exception.try = function(f)
	local success, result = pcall(f)

	return {catch=function(processors)
		if success then
			return result
		end

		if result.type then
			if not processors[result.type] then
				error(result)
			end

			return processors[result.type](result)
		end

		for k, v in pairs(processors) do
			if type(k) == "table" then
				local success = true
			
				for ix, it in ipairs(k) do
					if not tostring(result):find(it) then
						success = false
						break
					end
				end

				if success then
					return v(result)
				end
			end
		end

		error(result)
	end}
end

return exception
