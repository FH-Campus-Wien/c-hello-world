CC := gcc
CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -g
TARGET := build/hello
SOURCE := src/main.c

.PHONY: all build run clean

all: build

build: $(TARGET)

$(TARGET): $(SOURCE)
	mkdir -p build
	$(CC) $(CFLAGS) $(SOURCE) -o $(TARGET)

run: build
	./$(TARGET)

clean:
	rm -rf build
