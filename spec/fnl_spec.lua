describe("functional module", function()
  local fnl = require "fnl"

  describe("implicit_lambda decorator", function()
    it("should create anonymous functions for Nth argument", function()
      local f = fnl.implicit_lambda(2, "x") .. function(x, f_) return f_(x) end

      assert.are.equal(8, f(2, "x^3"))
    end)
  end)

  describe("filter function", function()
    it("should filter sequence by a given predicate", function()
      assert.are.same(
        {2, 4, 6, 8},
        {1, 2, 3, 4, 5, 6, 7, 8} / fnl.filter(function(ix, it) return it % 2 == 0 end)
      )
    end)
  end)

  describe("unpack function", function()
    it("should unpack a sequence", function()
      local seq = {1, 2, 3}

      local test = function(a, b, c)
        print(a, b, c)
        return a == 1 and b == 2 and c == 3
      end

      fnl_unpack = function(x) return (unpack or table.unpack)(x) end
      wrapper = function(f, ...) return f(...) end

      assert.are.same({ wrapper(fnl_unpack, seq) }, seq)
      --assert.is_true(test(seq / fnl.unpack()))
      -- assert.is_true(test(unpack(seq)))
    end)
  end)
end)
