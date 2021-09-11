describe("vector library", function()
  local vector = require 'structures.vector'

  describe("squared_magnitude method", function()
    it("works", function()
      assert.are.equal(55, vector(1, 2, 3, 4, 5):squared_magnitude())
    end)
  end)

  describe("rotation method", function()
    it("rotates 2d vectors", function()
      local rotated = vector(1, 0):rotated(math.pi / 2)

      assert.is_true(math.abs(rotated.x - 0) < 1e-10)
      assert.is_true(math.abs(rotated.y - 1) < 1e-10)
    end)
  end)
end)