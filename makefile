T= lxp
V= 1.3.3

# Default prefix
PREFIX ?= /usr

# Lua version and dirs
LUA_SYS_VER ?= 5.3
# System's libraries directory (where binary libraries will be installed)
LUA_LIBDIR ?= $(PREFIX)/lib/lua/$(LUA_SYS_VER)
# System's lua directory (where Lua libraries will be installed)
LUA_DIR ?= $(PREFIX)/share/lua/$(LUA_SYS_VER)
# Lua includes directory (where Lua header files were installed)
LUA_INC ?= $(PREFIX)/include/lua$(LUA_SYS_VER)

# Expat includes directory (where Expat header files were installed)
EXPAT_INC= /usr/include

# OS dependent
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin) # MacOS
	LIB_OPTION ?= -bundle -undefined dynamic_lookup -mmacosx-version-min=10.3
else # Linux/BSD
	LIB_OPTION ?= -shared #for Linux
endif

LIBNAME= $T.so.$V

# Compilation parameters
CWARNS = -Wall -pedantic \
        -Waggregate-return \
        -Wcast-align \
        -Wmissing-prototypes \
        -Wstrict-prototypes \
        -Wnested-externs \
        -Wpointer-arith \
        -Wshadow \
        -Wwrite-strings \
        -DLUA_C89_NUMBERS

CFLAGS = -fPIC -std=gnu99 $(CWARNS) -ansi -O2 -I$(LUA_INC) -I$(EXPAT_INC)
CC = gcc

OBJS= src/lxplib.o
lib: src/$(LIBNAME)

src/$(LIBNAME) : $(OBJS)
	$(CC) $(CFLAGS) -o src/$(LIBNAME) $(LIB_OPTION) $(OBJS) -lexpat

install:
	mkdir -p $(LUA_LIBDIR)
	cp src/$(LIBNAME) $(LUA_LIBDIR)
	cd $(LUA_LIBDIR); ln -f -s $(LIBNAME) $T.so
	mkdir -p $(LUA_DIR)/$T
	cp src/$T/lom.lua $(LUA_DIR)/$T

clean:
	rm -f src/$(LIBNAME) $(OBJS)
