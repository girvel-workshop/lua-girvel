package = "girvel"
version = "1.0-1"
source = {
   url = "https://github.com/girvel-workshop/lua-girvel",
   tag = "1.0-0"
}
description = {
   summary = "none",
   license = "MIT"
}
build = {
   type = "builtin",
   modules = {
      container = "container.lua",
      decorator = "decorator.lua",
      exception = "exception.lua",
      fnl = "fnl.lua",
      gamera = "gamera.lua",
      lambda = "lambda.lua",
      limited = "limited.lua",
      log = "log.lua",
      module = "module.lua",
      tesound = "tesound.lua",
      tk = "tk.lua",
      vector = "vector.lua"
   }
}
