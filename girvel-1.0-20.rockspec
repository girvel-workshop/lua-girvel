package = "girvel"
version = "1.0-20"
source = {
   url = "https://github.com/girvel-workshop/lua-girvel",
}
description = {
   summary = "girvel's functional framework",
   license = "MIT"
}
build = {
   type = "builtin",
   modules = {
      environment = "environment.lua",
      fnl = "fnl.lua",
      limited = "limited.lua",
      module = "module.lua",
      syntax = "syntax.lua",
      tk = "tk.lua",
      vector = "vector.lua"
   }
}
