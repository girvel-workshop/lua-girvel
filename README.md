# lua-girvel

Functional style library for lua providing tools to work with collections, syntax, lua environments, importing assets and modules.

## Demo

```lua
local fnl = require 'fnl'

local seq = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29}
  / fnl.filter(function(i, x) return x >= 5 end)
  / fnl.map(function(i, x) return x ^ 2 - 1 end)

local theorem_works = seq / fnl.all(function(i, x) return x % 24 == 0 end)
-- theorem_works == true

local fib = fnl.cache() .. function(n)
  return n == 1 or n == 2 and 1 or fib(n - 1) + fib(n - 2)
end
-- Now is cached

local syntax = require 'syntax'

local f = syntax.pipe() .. function(x) return x ^ 2 end
-- Now f is a pipe function

local a = 12 / f()
-- a == 144

local module = require 'module'
local assets = module 'assets'

print(-assets.demo_text_file)
-- Prints its content
```

## Installation

With luarocks:

```bash
git clone https://github.com/girvel-workshop/lua-girvel
cd lua-girvel
sudo luarocks build
```

## Documentation

(In progress)

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