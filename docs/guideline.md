# Guideline

## Syntax

Syntax library provides different objects for syntax extension.

### Decorator

Decorator `syntax.decorator` creates decorator from the function:

```lua
-- declaration of new decorator by syntax.decorator decorator
local dec = syntax.decorator() .. function(decorator_itself, decorated_value, argument_to_decorator1, ...)
	return replacement_for_value
end

-- usage
local value = dec(argument_to_decorator1, argument_to_decorator2) .. decorated_value
```
