# INSERT PROGRAM NAME HERE!!!
PROGRAM_NAME = myprogram

####################
# Shared Resources #############################################################
####################
ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # not in a bash-like shell
	CLEANUP = rmdir /S /Q
	MKDIR = mkdir
  else # in a bash-like shell, like msys
	CLEANUP = rm -r
	MKDIR = mkdir -p
  endif
	TARGET_EXTENSION=exe
else
	CLEANUP = rm -r
	MKDIR = mkdir -p
	TARGET_EXTENSION=out
endif

.PHONY: clean
.PHONY: test

COMPILE = gcc -c
LINK = gcc
DEPEND = gcc -MM -MG -MF
CFLAGS = -I. -I$(PATHU) -I$(PATHS) -I$(PATHI) -DTEST

PATHS = src/
PATHI = include/




####################
# Production Build #############################################################
####################
PATHB = build/

TARGET = $(PROGRAM_NAME).$(TARGET_EXTENSION)

SRCS = $(shell find $(PATHS) -name "*.c")

OBJECTS = $(patsubst $(PATHS)%.c,$(PATHB)%.o,$(SRCS))

$(TARGET): $(OBJECTS)
	$(LINK) $(OBJECTS) -o $@

# Compile object files.
$(PATHB)%.o: $(PATHS)%.c
# First, each object directory is created in the structure of the src directory
	@mkdir -p $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

# Clean build files
clean:
	$(CLEANUP) $(PATHB)
	@echo "cleaned the production build"


####################
# Unity Test Build #############################################################
####################
PATHT = test/
PATHU = unity/src/
PATH_TEST_B = test_build/
PATH_TEST_D = $(PATH_TEST_B)depends/
PATH_TEST_O = $(PATH_TEST_B)objs/
PATH_TEST_OS = $(PATH_TEST_O)src/
PATH_TEST_OT = $(PATH_TEST_O)test/
PATH_TEST_OU = $(PATH_TEST_O)unity/
PATH_TEST_R =  $(PATH_TEST_B)results/
PATH_TEST_E =  $(PATH_TEST_B)executables/



SRCT = $(shell find $(PATHT) -name "*.c")

RESULTS = $(patsubst $(PATHT)%Test.c,$(PATH_TEST_R)%Test.txt,$(SRCT))

show_results:
	@echo $(RESULTS)

showPath:
	@echo $(PATH_TEST_R)

PASSED = `grep -r -s PASS $(PATH_TEST_R)`
FAIL = `grep -r -s FAIL $(PATH_TEST_R)`
IGNORE = `grep -r -s IGNORE $(PATH_TEST_R)`

test: $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo "\nDONE"

$(PATH_TEST_R)%.txt: $(PATH_TEST_E)%.$(TARGET_EXTENSION)
	@$(MKDIR) $(dir $@)
	-./$< > $@ 2>&1


$(PATH_TEST_E)%Test.$(TARGET_EXTENSION): $(PATH_TEST_OT)%Test.o $(PATH_TEST_OS)%.o $(PATH_TEST_OU)unity.o #$(PATHD)Test%.d
	@$(MKDIR) $(dir $@)
	$(LINK) -o $@ $^

$(PATH_TEST_OT)%.o:: $(PATHT)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_TEST_OS)%.o:: $(PATHS)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_TEST_OU)%.o:: $(PATHU)%.c $(PATHU)%.h
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_TEST_D)%.d:: $(PATHT)%.c
	@$(MKDIR) $(dir $@)
	$(DEPEND) $@ $<



cleantest:
	$(CLEANUP) $(PATH_TEST_B)
	@echo "cleaned the test build"

.PRECIOUS: $(PATHE)%Test.$(TARGET_EXTENSION)
.PRECIOUS: $(PATHD)%.d
.PRECIOUS: $(PATHOS)%.o
.PRECIOUS: $(PATHOT)%.o
.PRECIOUS: $(PATHOU)%.o
.PRECIOUS: $(PATHR)%.txt