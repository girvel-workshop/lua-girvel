# Future features

## Match expression

```lua
local match = require "match"
local fnl = require "fnl"

-- maybe this
local predicate = {pcall(lambda, arg)} / match {
  [{true, match.arg(1)}] = fnl.one,
  [{false, match.where{type="syntax_error"}}] = function() return fnl.zero end,
  [{false, match.arg(1)}] = error,
}

-- or maybe this
local predicate = match(pcall(lambda, arg))
	.. case{true}                                    - fnl.redirect(2)
	.. case{false, match.where{type="syntax_error"}} - fnl.static(fnl.zero)
	.. case{false}                                   - fnl.combine/error * fnl.redirect(2)
```
