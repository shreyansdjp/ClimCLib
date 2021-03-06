
LIB_NAME = ClimCLib

PREFIX := /usr/local

SOURCE_DIR = src
INCLUDE_DIR = include -Idep/SDL2-2.0.4/include -Idep/SDL2_image-2.0.1


DEPS_DIR = dep/
DEPS = -lSDL2
LINUXDEPS_DIR = dep/Linux

LIB_DIR = bin

LIB = $(LIB_DIR)/$(LIB_NAME).a

OBJS  = $(patsubst $(SOURCE_DIR)/adt/%.c,$(SOURCE_DIR)/adt/%.o,$(wildcard $(SOURCE_DIR)/adt/*.c))
OBJS += $(patsubst $(SOURCE_DIR)/physics/%.c,$(SOURCE_DIR)/physics/%.o,$(wildcard $(SOURCE_DIR)/physics/*.c))
OBJS += $(patsubst $(SOURCE_DIR)/utility/%.c,$(SOURCE_DIR)/utility/%.o,$(wildcard $(SOURCE_DIR)/utility/*.c))
OBJS += $(patsubst $(SOURCE_DIR)/graphics/%.c,$(SOURCE_DIR)/graphics/%.o,$(wildcard $(SOURCE_DIR)/graphics/*.c))


CFLAGS :=  -g -Wall -Werror -pedantic-errors -std=c11 -I$(INCLUDE_DIR)

 .PHONY: all clean make_local rm_Local test

all: $(LIB)

$(LIB): $(OBJS)
	mkdir -p $(LIB_DIR)
	ar rcs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<  -o $@

clean:
	rm -Rf bin
	find $(SOURCE_DIR) -name "*.o" -delete
	find include -name "*.gch" -delete

install:
	mkdir -p $(PREFIX)/include/climclib
	mkdir -p $(PREFIX)/lib
	cp $(LIB) $(PREFIX)/lib
	cp -R include/* $(PREFIX)/include/climclib

testless:
		$(CC) -Wall -std=c11 -I$(INCLUDE_DIR) -c tests/test1.c -o ClimCTest.o -Ldep/ -lLinux/SDL2/build/.libs/SDL2  -lm -lSDL2 -lSDL2_image
		$(CC) -g -o Test1 ClimCTest.o  bin/ClimCLib.a -lm -lSDL2 -lSDL2_image

test:
	$(CC) $(CFLAGS) -c tests/test1.c -o ClimCTest.o
	$(CC) -g -o Test1 ClimCTest.o  bin/ClimCLib.a -lm -lSDL2 -lSDL2_image
