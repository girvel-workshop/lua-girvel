describe("functional module", function()
  local fnl = require "fnl"
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

      --assert.are.same(seq, {seq / fnl.unpack()})
      assert.are.same(seq, {fnl.unpack.base_function(seq)})
    end)
  end)

  describe("cache decorator", function()
    it("should cache results", function()
      local call_counter = 0
      local f = fnl.cache() .. function(a, b, c)
        call_counter = call_counter + 1
        return a + b + c
      end

      f(1, 2, 3)
      f(1, 2, 3)

      assert.are.equal(1, call_counter)
    end)
  end)
end)
