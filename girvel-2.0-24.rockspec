package = "girvel"
version = "2.0-24"
source = {
   url = "git://github.com/girvel-workshop/lua-girvel"
}
description = {
   summary = "girvel's own functional-style lua framework",
   homepage = "http://girvel.xyz",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1, < 5.4"
}
build = {
   type = "builtin",
   modules = {
      env = "env.lua",
      fnl = "fnl.lua",
      limited = "limited.lua",
      module = "module.lua",
      tk = "tk.lua",
      vector = "vector.lua"
   }
}
