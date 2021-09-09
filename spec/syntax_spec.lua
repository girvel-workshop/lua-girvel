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
      local f = syntax.pipe() .. function(it, value) return it[1] == value end
      assert.is_true({"piper"} / f "piper")
    end)
  end)

  describe("syntax.lambda function", function()
    it("should create function from lambda string", function()
      local f = syntax.lambda "x -> x"
      local it_works = f(true)
      assert.is_true(it_works)
    end)
  end)
end)