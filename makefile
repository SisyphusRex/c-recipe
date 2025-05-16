# Define source and header directories
SRCDIR := src
INCDIR := include
BUILDDIR := build
TARGET := myprogram.exe

# Compiler and flags
CC := gcc
CFLAGS := -Wall -g -I$(INCDIR)

#Source Files: recursive depth
SOURCES := $(shell find $(SRCDIR) -name "*.c")

#Create List of objects to be created from source files
OBJECTS := $(patsubst $(SRCDIR)/%.c,$(BUILDDIR)/%.o,$(SOURCES))


# Default target
all: $(TARGET)

# Compile object files.
$(BUILDDIR)/%.o: $(SRCDIR)/%.c
# First, each object directory is created in the structure of the src directory
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Link object files
$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@

# Clean build files
clean:
	rm -rf $(BUILDDIR)
	rm $(TARGET)