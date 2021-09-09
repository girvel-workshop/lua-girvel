describe("toolkit library", function()
  local tk = require "tk"

  describe("tree object", function()
    it("easily creates new subtables", function()
      local tree = tk.tree()

      tree.a.b.c.d = 1
      assert.are.equal(1, tree.a.b.c.d)
    end)
  end)
end)