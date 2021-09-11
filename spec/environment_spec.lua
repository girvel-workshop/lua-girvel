describe("environment library", function()
  local environment = require "environment"

  describe("push function", function()
    it("pushes upper environment", function()
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

  describe("append function", function()
    it("makes the env available inside the function", function()
      local it_works = environment.append(
        {f = function() return true end},
        function()
          return f()
        end
      )

      assert.is_true(it_works)
    end)

    it("can be nested", function()
      local it_works = environment.append({a=1}, function()
        return environment.append({result=true}, function()
          return result
        end)
      end)

      assert.is_true(it_works)
    end)
  end)
end)