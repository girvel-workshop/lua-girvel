describe("module library", function()
  local module = require 'module'

  describe("main importing mechanism", function()
    local assets = module "spec.module_assets"

    it("should be a basic shortcut for require", function()
      assert.are_equal("Hello", -assets.simple_library)
    end)

    it("should create a possibility to import entire directories", function()
      local directory = -assets.folder_with_libraries
      assert.are_equal(true, directory.truth)
    end)

    it("should use _representation.lua files", function()
      local custom_directory = -assets.folder_with_custom_importing_mechanism
      print(require[[inspect]](custom_directory))
      assert.are_equal("This is a file", custom_directory.file)
      assert.are_equal(nil, custom_directory.does_not_load)
    end)
  end)
end)