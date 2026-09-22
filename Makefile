CC := gcc
CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -g
TARGET := build/hello
SOURCE := src/main.c
ARGS :=

.PHONY: all build run debug clean

all: build

build: $(TARGET)

$(TARGET): $(SOURCE)
	mkdir -p build
	$(CC) $(CFLAGS) $(SOURCE) -o $(TARGET)

run: build
	./$(TARGET) $(ARGS)

debug: build
	gdb --args ./$(TARGET) $(ARGS)

clean:
	rm -rf build
