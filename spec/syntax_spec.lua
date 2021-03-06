describe("syntax module", function()
  local syntax = require "syntax"

  describe("syntax.decorator function", function()
    it("should create decorators", function()
      local it_works = false

      local decorator = syntax.decorator() .. function()
        it_works = true
        return "Tadam!"
      end

      local result = decorator() .. 0

      assert.is_true(it_works)
      assert.are.equal("Tadam!", result)
    end)
  end)

  describe("syntax.pipe decorator", function()
    it("should make function piped", function()
      local eq = syntax.pipe() .. function(it, value) return it[1] == value end
      assert.is_true({"piper"}/eq "piper")
    end)
  end)

  describe("syntax.lambda function", function()
    it("should create function from lambda string", function()
      local f = syntax.lambda "x -> x"
      local it_works = f(true)
      assert.is_true(it_works)
    end)
  end)

  describe("syntax.implicit_lambda decorator", function()
    it("should make on of the arguments an implicit lambda", function()
      local apply = syntax.implicit_lambda(1, "x") .. function(f, x) return f(x) end
      assert.are.equal(64, apply("x^2", 8))
    end)
  end)

  describe("syntax.context decorator", function()
		it("provides context expressions", function()
			local arithmetics = syntax.context() .. {
				__add = function(left, right)
					return left.v + right.v
				end
			}

			local a = {v=7}
			local b = {v=5}

			assert.are_equal(12, arithmetics/a + b)
		end)
		
		-- local sum = arithmetics(function() return a + b end)?
		-- local sum = arithmetics "a + b"?
  end)
end)
