local decorator = require "decorator"
require "strong"
local lambda = require "lambda"

local fnl = {}

-- TODO move to another place
fnl.docs = decorator:new(function(self, f, documentation)
	self[f] = documentation
	return f
end)

fnl.docs = fnl.docs{
	type='decorator',
	description=[=[
		assigns some documentation to a value, 
		that later can be get by fnl.docs[<value>]
	]=]
} .. fnl.docs

fnl.pipe = 
	fnl.docs{
		type='decorator', 
		description='makes function `f(t, ...)` a pipe function `t / f(...)`',
		args={

		}
	} .. 
	decorator:new(function(_, f)
		return function(...)
			return setmetatable({args = {...}}, {
				__div = function(table, self)
					return f(table, unpack(self.args))
				end
			})
		end
	end)

fnl.filter = 
	fnl.docs{
		type='pipe function',
		description='filters table by ipairs',
		args={
			'input sequence',
			'predicate function(ix, it) or implicit (ix, it) lambda'
		}
	} ..
	fnl.pipe() .. 
	function(t, predicate)
		if type(predicate) == "string" then
			predicate = lambda("ix, it -> " .. predicate)
		end

		local result = {}
		for i, v in ipairs(t) do
			if predicate(i, v) then
				table.insert(result, v)
			end
		end
		return result
	end
	
fnl.map = 
	fnl.docs{} ..
	fnl.pipe() ..
	function(t, f)
		if type(f) == "string" then
			f = lambda("ix, it -> " .. f)
		end
	
		local result = {}
		for ix, it in ipairs(t) do
			table.insert(result, f(ix, it))
		end
		return result
	end

fnl.separate = 
	fnl.docs{
		type='pipe function'
	} ..
	fnl.pipe() ..
	function(t, separator)
		if #t == 0 then return {} end
	
		local result = {t[1]}
		for i = 2, #t do
			table.insert(result, separator)
			table.insert(result, t[i])
		end
		return result
	end

fnl.join = 
	fnl.docs{} ..
	fnl.pipe() ..
	function(t, metamethod)
		metamethod = metamethod or "__add"
		
		if #t == 0 then return end

		local result = t[1]
		
		for i = 2, #t do
			result = getmetatable(result)[metamethod](result, t[i])
		end
		return result
	end
	
-- TODO optimization: pipe + ipairs
fnl.slice = 
	fnl.docs{
		type='pipe function',
		returns='slice of the sequence'
	} ..
	fnl.pipe() ..
	function(t, first, last, step)
		if last and last < 0 then
			last = #t + last + 1
		end
	
		local result = {}
		for i = first or 1, last or #t, step or 1 do
			table.insert(result, t[i])
		end
		return result
	end

fnl.inspect = 
	fnl.docs{} ..
	fnl.pipe() ..
	require "inspect"
	
-- TODO pipe functions as normal functions
fnl.unpack =
	fnl.docs{
		type='pipe function',
		description='pipe function for table.unpack / unpack'
	} ..
	fnl.pipe() ..
	table.unpack or unpack

fnl.values = 
	fnl.docs{
		type='pipe function',
		returns='sequence of values of table t',
		args={'table'}
	} ..
	fnl.pipe() .. 
	function(t)
		result = {}
		for k, v in pairs(t) do
			table.insert(result, v)
		end
		return result
	end

fnl.remove =
	fnl.docs{
		type='function',
		description='removes first value from table',
		returns='removed value or nil'
	} ..
	function(t, value)
		for i, v in ipairs(t) do
			if v == value then
				table.remove(t, i)
				return value
			end
		end
	end

-- fnl.extend = fnl.pipe() .. function(table1, table2) -- TODO
-- fnl.extend = 
--   fnl.docs{
--     type='pipe functions',
--     returns='first table extended by second'
--   } ..
--   fnl.pipe() ..
--  function(table1, table2)
function fnl.extend(table1, table2)
	result = table1 / fnl.copy()
	for k, v in pairs(table2) do
		result[k] = v
	end
	return result
end

fnl.copy = nil
fnl.copy = 
	fnl.docs{
		type='pipe function',
		returns='copy of value',
		args={
			'value',
			'table of already copied tables for reference preserving',
			'disable recursive copying'
		}
	} ..
	fnl.pipe() .. 
	function(t, cache, not_deep)
		if t == nil then return nil end

		if type(t) ~= "table" then return t end
		if not cache then cache = {} end
		if cache[t] then return cache[t] end

		if t.copy ~= nil then
			return t:copy()
		end

		local result = {}

		setmetatable(result, getmetatable(t))
		cache[t] = result

		for k, v in pairs(t) do
			if not_deep or type(v) ~= "table" then
				result[k] = v
			else
				result[k] = v / fnl.copy(cache)
			end
		end
		return result
	end

fnl.inherit = 
	fnl.docs{
		type='pipe function',
		description='sets metatable & parent\'s __index',
		returns='child',
		args={'child', 'parent'}
	} ..
	fnl.pipe() .. 
	function(child, parent)
		setmetatable(child, parent)
		parent.__index = parent
		return child
	end

fnl.contains = 
	fnl.docs{
		type='pipe function',
		returns='is value in collection',
		args={'collection', 'value'}
	} ..
	fnl.pipe() .. 
	function(collection, element)
		return #(collection / fnl.filter[[it == element]]) > 0
	end

return fnl
