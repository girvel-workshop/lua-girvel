## Lua-girvel 3.0

### Match expression

```lua
local match = require "match"
local fnl = require "fnl"

local predicate = match {pcall(lambda, arg)} {
  [{true, match.arg(1)}] = fnl.one,
  [{false, match.where{type="syntax_error"}}] = function() return fnl.zero end,
  [{false, match.arg(1)}] = error,
}
```


### Syntax changes

```lua
-- OLD SYNTAX
a = t / fnl.map(to_boolean) / fnl.fold "or"
b = fnl.range(1, 5) / fnl.map "it ^ 2" / fnl.filter "it > 10" / fnl.inspect()

-- NEW SYNTAX
a = fnl.ipairs(t):map(to_boolean):fold("or")
b = fnl.range(1, 5):map[[it^2]]:filter[[it > 20]]:inspect()
```