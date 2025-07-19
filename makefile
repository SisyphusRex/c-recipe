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

# Compiler Commands
CC = gcc
COMPILE = $(CC) -c
LINK = $(CC)
CFLAGS = -I$(PATH_I)
CPPFLAGS = -MMD -MF

##############
# TEST BUILD #
##############

# Test Compiler Commands
TCFLAGS = $(CFLAGS) -I$(PATH_U)

# Test Directory paths
PATH_T = test/
PATH_U = unity/src/
PATH_TB = testbuild/
PATH_TB_D = $(PATH_TB)depends/
PATH_TB_D_S = $(PATH_TB_D)src/
PATH_TB_D_T = $(PATH_TB_D)test/
PATH_TB_O = $(PATH_TB)objs/
PATH_TB_O_S = $(PATH_TB_O)src/
PATH_TB_O_T = $(PATH_TB_O)test/
PATH_TB_O_U = $(PATH_TB_O)unity/
PATH_TB_R = $(PATH_TB)results/
PATH_TB_N = $(PATH_TB)bin/

# Find test file paths recursively
SRC_T = $(shell find $(PATH_T) -name "*.c")

# Find src file paths, excluding main, recursively
SRC_S_NOMAIN = $(shell find $(PATH_S) -name "*.c" -not -name "main.c")

# Get List of Objects
SRC_O_S_NOMAIN = $(patsubst $(PATH_S)%.c,$(PATH_TB_O_S)%.o,$(SRC_S_NOMAIN))
SRC_O_T = $(patsubst $(PATH_T)%.c,$(PATH_TB_O_T)%.o,$(SRC_T))

# Get list of depends files
DEPEND_S_NOMAIN = $(patsubst $(PATH_TB_O_S)%.o,$(PATH_TB_D_S)%.d,$(SRC_O_S_NOMAIN))
DEPEND_T = $(patsubst $(PATH_TB_O_T)%.o,$(PATH_TB_D_T)%.d,$(SRC_O_T))
ALL_DEPEND_NOMAIN = $(DEPEND_S_NOMAIN) $(DEPEND_T)

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
$(PATH_TB_N)%Test.$(TARGET_EXTENSION): $(PATH_TB_O_T)%Test.o $(PATH_TB_O_U)unity.o $(SRC_O_S_NOMAIN)
	@$(MKDIR) $(dir $@)
	$(LINK) -o $@ $^

# Build test object files
$(PATH_TB_O_T)%.o: $(PATH_T)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(TCFLAGS) $(CPPFLAGS) "$(@:$(PATH_TB_O_T)%.o=$(PATH_TB_D_T)%.d)" $< -o $@

# Build source object files
$(PATH_TB_O_S)%.o: $(PATH_S)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(TCFLAGS) $(CPPFLAGS) "$(@:$(PATH_TB_O_S)%.o=$(PATH_TB_D_S)%.d)" $< -o $@

# Build unity object files
$(PATH_TB_O_U)%.o:: $(PATH_U)%.c $(PATH_U)%.h
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

# Make Depend file directories
$(ALL_DEPEND_NOMAIN):
	@$(MKDIR) $(PATH_TB)
	@$(MKDIR) $(dir $@)



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


PATH_S = src/
PATH_B = build/
PATH_I = include/
PATH_N = bin/
PATH_B_O = $(PATH_B)objs/
PATH_B_D = $(PATH_B)depends/

# Entry point
production: $(TARGET)

TARGET = $(PATH_N)$(PROGRAM_NAME).$(TARGET_EXTENSION)

# Find all src file paths relative to src directory
SRC_S = $(shell find $(PATH_S) -name "*.c")

# Create list of all object files to be created with paths relative to build directory
OBJECTS = $(patsubst $(PATH_S)%.c,$(PATH_B_O)%.o,$(SRC_S))

# Get list of depends files
DEPEND_S = $(patsubst $(PATH_B_O)%.o,$(PATH_B_D)%.d,$(OBJECTS))

# Build executable by linking objects
$(TARGET): $(OBJECTS)
	$(LINK) -o $@ $^

# Compile object files.  Create path/directory of object file and then compile.
$(PATH_B_O)%.o: $(PATH_S)%.c
	@mkdir -p $(dir $@)
	$(COMPILE) $(CFLAGS) $(CPPFLAGS) "$(@:$(PATH_B_O)%.o=$(PATH_B_D)%.d)" $< -o $@

$(DEPEND_S):
	@$(MKDIR) $(PATH_B)
	@$(MKDIR) $(dir $@)

# Clean build files
cleanproduction:
	$(CLEANUP) $(PATH_B)
	$(CLEANUP) $(TARGET)
	@echo "cleaned the production build"

#################################
# Test Dependency Rule Addition #
#################################
-include $(ALL_DEPEND_NOMAIN)

#######################################
# Production Dependency Rule Addition #
#######################################
-include $(DEPEND_S)