T= lxp
V= 1.3.0

# Installation directories
# System's libraries directory (where binary libraries will be installed)
LUA_LIBDIR= /usr/local/lib/lua/5.1
# System's lua directory (where Lua libraries will be installed)
LUA_DIR= /usr/local/share/lua/5.1
# Lua includes directory (where Lua header files were installed)
LUA_INC= /usr/local/include
# Expat includes directory (where Expat header files were installed)
EXPAT_INC= /usr/local/include

# OS dependent
LIB_OPTION= -shared #for Linux
#LIB_OPTION= -bundle -undefined dynamic_lookup #for MacOS X

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
        -Wwrite-strings

CFLAGS = $(CWARNS) -ansi -O2 -I$(LUA_INC) -I$(EXPAT_INC)
CC = gcc

OBJS= src/lxplib.o
lib: src/$(LIBNAME)

src/$(LIBNAME) : $(OBJS)
	$(CC) -o src/$(LIBNAME) $(LIB_OPTION) $(OBJS) -lexpat

install:
	mkdir -p $(LUA_LIBDIR)
	cp src/$(LIBNAME) $(LUA_LIBDIR)
	cd $(LUA_LIBDIR); ln -f -s $(LIBNAME) $T.so
	mkdir -p $(LUA_DIR)/$T
	cp src/$T/lom.lua $(LUA_DIR)/$T

clean:
	rm -f src/$(LIBNAME) $(OBJS)
