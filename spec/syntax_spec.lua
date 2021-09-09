describe("syntax module", function()
  local syntax = require "syntax"

  describe("syntax.decorator function", function()
    it("should create decorators", function()
      local it_works = false

      local decorator = syntax.decorator(function()
        it_works = true
        return "Tadam!"
      end)

      local result = decorator() .. 0

      assert.is_true(it_works)
      assert.are.equal("Tadam!", result)
    end)
  end)

  describe("pipe decorator", function()
    it("should make function piped", function()
      local f = syntax.pipe() .. function(it, value) return it[1] == value end
      assert.is_true({"piper"} / f "piper")
    end)
  end)
end)