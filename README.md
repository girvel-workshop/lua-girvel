## Future features

### Match expression

```lua
local match = require "match"
local fnl = require "fnl"

local predicate = {pcall(lambda, arg)} / match {
  [{true, match.arg(1)}] = fnl.one,
  [{false, match.where{type="syntax_error"}}] = function() return fnl.zero end,
  [{false, match.arg(1)}] = error,
}
```