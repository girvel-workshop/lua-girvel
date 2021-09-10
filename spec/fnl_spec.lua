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

  describe("map function", function()
    it("maps one sequence to another using the given function", function()
      assert.are.same(
        {1, 4, 9, 16},
        {1, 2, 3, 4} / fnl.map(function(ix, it) return it^2 end)
      )
    end)
  end)

  describe("all function", function()
    it("checks whether all the elements of the sequence are truthy", function()
      assert.is_true({true, "123", "a", {}} / fnl.all())
      assert.is_false({false, true, 123} / fnl.all())
    end)

    it("can pre-map sequence", function()
      assert.is_true(
        {"123", "2312", "4133412"} / fnl.all(function(ix, it) return #it > 2 end)
      )
      assert.is_false(
        {"12", "123"} / fnl.all(function(ix, it) return #it > 2 end)
      )
    end)
  end)

  describe("separate function", function()
    it("separates the sequence by a given item", function()
      assert.are.same(
        {1, 0, 2, 0, 3, 0, 4},
        {1, 2, 3, 4} / fnl.separate(0)
      )
    end)
  end)

  describe("fold function", function()
    it("folds the sequence by a given function", function()
      assert.are_equal(
        63,
        {1, 2, 4, 8, 16, 32} / fnl.fold(function(a, b) return a + b end)
      )
    end)

    it("folds the sequence by a given metamethod", function()
      function some_object(a)
        return setmetatable({value=a}, {__sub=function(self, other)
          return some_object(self.value - other.value)
        end})
      end

      assert.are_equal(
        1,
        ({some_object(82), some_object(40), some_object(41)}
          / fnl.fold "__sub").value
      )
    end)

    it("concatenates strings", function()
      assert.are_equal("1234", {"1", "2", "3", "4"} / fnl.fold())
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
