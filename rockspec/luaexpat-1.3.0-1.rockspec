package = "LuaExpat"
version = "1.3.0-1"
source = {
   url = "https://github.com/tomasguisasola/luaexpat/archive/v1_3_0.tar.gz",
   md5 = "b45d9d1caa1c6acf4bfc54802ab8ec4c",
   dir = "luaexpat-1_3_0",
}
description = {
   summary = "XML Expat parsing",
   detailed = [[
      LuaExpat is a SAX (Simple API for XML) XML parser based on the
      Expat library.
   ]],
   license = "MIT/X11",
   homepage = "http://www.keplerproject.org/luaexpat/"
}
dependencies = {
   "lua >= 5.0"
}
external_dependencies = {
   EXPAT = {
      header = "expat.h"
   }
}
build = {
   type = "builtin",
   modules = {
    lxp = { 
      sources = { "src/lxplib.c" },
      libraries = { "expat" },
      incdirs = { "$(EXPAT_INCDIR)", "src/" },
      libdirs = { "$(EXPAT_LIBDIR)" }
    },
    ["lxp.lom"] = "src/lxp/lom.lua"
   },
   copy_directories = { "doc", "tests" }
}
