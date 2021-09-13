package = "girvel"
version = "2.0-82"
source = {
   url = "git://github.com/girvel-workshop/lua-girvel"
}
description = {
   summary = "girvel's own functional-style lua framework",
   homepage = "http://girvel.xyz",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1, < 5.4",
   "strong >= 1.0.4-1",
   "luafilesystem >= 1.8.0-1"
}
build = {
   type = "builtin",
   modules = {
      env = "env.lua",
      fnl = "fnl.lua",
      module = "module.lua",
      ["structures.limited"] = "structures/limited.lua",
      ["structures.vector"] = "structures/vector.lua",
      tk = "tk.lua"
   }
}
