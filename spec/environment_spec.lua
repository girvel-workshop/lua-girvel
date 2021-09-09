describe("environment library", function()
  local environment = require "environment"

  describe("push function", function()
    it("should push upper environment", function()
      local it_works = false

      local f = function()
        environment.push(_ENV or getfenv())
        it_works = a == 1
      end
      local a = 1
      f()

      assert.is_true(it_works)
    end)
  end)

  describe("use function", function()
    it("should use given environment", function()
      local it_works = false

      environment.use({f = function() it_works = true end}, function()
        f()
      end)

      assert.is_true(it_works)
    end)
  end)
end)