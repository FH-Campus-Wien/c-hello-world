CC := gcc
CPPFLAGS := -Iinclude
CFLAGS := -std=c17 -Wall -Wextra -Wpedantic -Wconversion -g

TARGET := build/hello

# Weitere Dateien hier mit Leerzeichen getrennt ergänzen, zum Beispiel:
# SOURCES := src/main.c src/minmax.c
# HEADERS := include/minmax.h
SOURCES := src/main.c
HEADERS :=

ARGS :=

.PHONY: all build run debug clean

all: build

build: $(TARGET)

$(TARGET): $(SOURCES) $(HEADERS)
	mkdir -p build
	$(CC) $(CPPFLAGS) $(CFLAGS) $(SOURCES) -o $(TARGET)

run: build
	./$(TARGET) $(ARGS)

debug: build
	gdb --args ./$(TARGET) $(ARGS)

clean:
	rm -rf build
