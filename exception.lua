local exception = {}

function exception.throw(ex)
	ex.author = debug.getinfo(2).name
	error(setmetatable(ex, {
		__tostring = function(self) return self.message end
	}))
end

return exception
