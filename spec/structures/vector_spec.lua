describe("vector library", function()
  local vector = require 'structures.vector'

  describe("squared_magnitude method", function()
    it("works", function()
      assert.are.equal(55, vector(1, 2, 3, 4, 5):squared_magnitude())
    end)
  end)
end)