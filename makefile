# INSERT PROGRAM NAME HERE!!!
PROGRAM_NAME = myprogram

#####################
# SHARED BUILD INFO #
#####################

# Check OS and determine correct commands
ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # not in a bash-like shell
	CLEANUP = rmdir /S /Q
	MKDIR = mkdir
  else # in a bash-like shell, like msys
	CLEANUP = rm -r -f
	MKDIR = mkdir -p
  endif
	TARGET_EXTENSION=exe
else
	CLEANUP = rm -r -f
	MKDIR = mkdir -p
	TARGET_EXTENSION=out
endif

# Prevent file name interference
.PHONY: production
.PHONY: cleanproduction
.PHONY: test
.PHONY: cleantest

# Directories. TB indicates testbuild directories.
PATH_U = unity/src/
PATH_S = src/
PATH_T = test/
PATH_B = build/
PATH_I = include/
PATH_N = bin/
PATH_TB = testbuild/
PATH_TB_D = $(PATH_TB)depends/
PATH_TB_O = $(PATH_TB)objs/
PATH_TB_O_S = $(PATH_TB_O)src/
PATH_TB_O_T = $(PATH_TB_O)test/
PATH_TB_O_U = $(PATH_TB_O)unity/
PATH_TB_R = $(PATH_TB)results/
PATH_TB_N = $(PATH_TB)bin/

# Compiler Commands
COMPILE=gcc -c
LINK=gcc
DEPEND=gcc -MM -MG -MF
CFLAGS=-I. -I$(PATH_U) -I$(PATH_S) -I$(PATH_I) -DTEST

##############
# TEST BUILD #
##############

# Find test file paths recursively
SRC_T = $(shell find $(PATH_T) -name "*.c")

# Convert test files to .txt keeping same path
RESULTS = $(patsubst $(PATH_T)%Test.c,$(PATH_TB_R)%Test.txt,$(SRC_T))

# Search for test results in .txt files
PASSED = `grep -r -s PASS $(PATH_TB_R)`
FAIL = `grep -r -s FAIL $(PATH_TB_R)`
IGNORE = `grep -r -s IGNORE $(PATH_TB_R)`

# Test entry point
test: $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo "\nDONE"

# Build results from executables
$(PATH_TB_R)%.txt: $(PATH_TB_N)%.$(TARGET_EXTENSION)
	@$(MKDIR) $(dir $@)
	-./$< > $@ 2>&1

# Build executables for each test by linking relevant object files
$(PATH_TB_N)%Test.$(TARGET_EXTENSION): $(PATH_TB_O_T)%Test.o $(PATH_TB_O_S)%.o $(PATH_TB_O_U)unity.o #$(PATH_TB_D)%Test.d
	@$(MKDIR) $(dir $@)
	$(LINK) -o $@ $^

# Build test object files
$(PATH_TB_O_T)%.o:: $(PATH_T)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

# Build source object files
$(PATH_TB_O_S)%.o:: $(PATH_S)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

# Build unity object files
$(PATH_TB_O_U)%.o:: $(PATH_U)%.c $(PATH_U)%.h
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

# Build depend files
$(PATH_TB_D)%.d:: $(PATH_T)%.c
	@$(MKDIR) $(dir $@)
	$(DEPEND) $@ $<

# Clean test build
cleantest:
	$(CLEANUP) $(PATH_TB)
	@echo "cleaned the test build"

# Prevent intermediate files from being deleted
.PRECIOUS: $(PATH_TB_N)%Test.$(TARGET_EXTENSION)
.PRECIOUS: $(PATH_TB_D)%.d
.PRECIOUS: $(PATH_TB_O_S)%.o
.PRECIOUS: $(PATH_TB_O_T)%.o
.PRECIOUS: $(PATH_TB_O_U)%.o
.PRECIOUS: $(PATH_TB_R)%.txt

####################
# Production Build #
####################

TARGET = $(PATH_N)$(PROGRAM_NAME).$(TARGET_EXTENSION)

# Entry point
production: $(TARGET)

# Find all src file paths relative to src directory
SRC_S = $(shell find $(PATH_S) -name "*.c")

# Create list of all object files to be created with paths relative to build directory
OBJECTS = $(patsubst $(PATH_S)%.c,$(PATH_B)%.o,$(SRC_S))

# Build executable by linking objects
$(TARGET): $(OBJECTS)
	$(LINK) $(OBJECTS) -o $@

# Compile object files.  Create path/directory of object file and then compile.
$(PATH_B)%.o: $(PATH_S)%.c
	@mkdir -p $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

# Clean build files
cleanproduction:
	$(CLEANUP) $(PATH_B)
	$(CLEANUP) $(TARGET)
	@echo "cleaned the production build"