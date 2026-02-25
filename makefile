# Copyright 2025 Theodore Podewil
# GPL-3.0-or-later

# NAME YOUR PROGRAM HERE
PROGRAM_NAME = myprogram

# Set default goal if no argument passed to make
.DEFAULT_GOAL = production

# ENVIRONMENT CHECK
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

# TARGETS NOT FILES
.PHONY: test
.PHONY: cleantest
.PHONY: production
.PHONY: cleanproduction
.PHONY: clean

# DIRECTORY PATHS
#	Shared Paths
PATH_S = src/
PATH_I = include/
#	Test Build Paths
PATH_T = test/
PATH_TB = testbuild/
PATH_U = unity/src/
PATH_TB_D = $(PATH_TB)depends/
PATH_TB_D_S = $(PATH_TB_D)src/
PATH_TB_D_T = $(PATH_TB_D)test/
PATH_TB_O = $(PATH_TB)objs/
PATH_TB_O_S = $(PATH_TB_O)src/
PATH_TB_O_T = $(PATH_TB_O)test/
PATH_TB_O_U = $(PATH_TB_O)unity/
PATH_TB_R = $(PATH_TB)results/
PATH_TB_N = $(PATH_TB)bin/
#	Production Build Paths
PATH_B = build/
PATH_B_D = $(PATH_B)depends/
PATH_B_O = $(PATH_B)objs/
PATH_B_N = $(PATH_B)bin/

# SOURCE CODE, OBJECTS, DEPENDS
#	Test Source
SRC_T = $(shell find $(PATH_T) -name "*.c")
SRC_S_NOMAIN = $(shell find $(PATH_S) -name "*.c" -not -name "main.c")
#	Test Objects
SRC_TB_O_S = $(patsubst $(PATH_S)%.c,$(PATH_TB_O_S)%.o,$(SRC_S_NOMAIN))
SRC_TB_O_T = $(patsubst $(PATH_T)%.c,$(PATH_TB_O_T)%.o,$(SRC_T))
#	Test Depends
DEPEND_TB_S = $(patsubst $(PATH_TB_O_S)%.o,$(PATH_TB_D_S)%.d,$(SRC_TB_O_S))
DEPEND_TB_T = $(patsubst $(PATH_TB_O_T)%.o,$(PATH_TB_D_T)%.d,$(SRC_TB_O_T))
ALL_DEPEND_TB = $(DEPEND_TB_S) $(DEPEND_TB_T)
#	Production Source
SRC_S = $(shell find $(PATH_S) -name "*.c")
#	Production Objects
SRC_B_O = $(patsubst $(PATH_S)%.c,$(PATH_B_O)%.o,$(SRC_S))
#	Production Depends
DEPEND_B = $(patsubst $(PATH_B_O)%.o,$(PATH_B_D)%.d,$(SRC_B_O))

# COMPILER
CC = gcc
CFLAGS = -I$(PATH_I) -Wall
TEST_CFLAGS = $(CFLAGS) -I$(PATH_U)
CPPFLAGS = -MMD -MF
COMPILE = $(CC) -c
LINK = $(CC)

##############
# TEST BUILD #
##############

# TEST VARIABLES
RESULTS = $(patsubst $(PATH_T)%Test.c,$(PATH_TB_R)%Test.txt,$(SRC_T))
PASSED = `grep -r -s PASS $(PATH_TB_R)`
FAIL = `grep -r -s FAIL $(PATH_TB_R)`
IGNORE = `grep -r -s IGNORE $(PATH_TB_R)`

# ENTRY POINT
test: $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo "\nDONE"

# CREATE RESULTS OF TEST EXECUTABLE
$(PATH_TB_R)%.txt: $(PATH_TB_N)%.$(TARGET_EXTENSION)
	@$(MKDIR) $(dir $@)
	-./$< > $@ 2>&1

# CREATE TEST EXECUTABLE BY LINKING OBJECTS
$(PATH_TB_N)%Test.$(TARGET_EXTENSION): $(PATH_TB_O_T)%Test.o $(PATH_TB_O_U)unity.o $(SRC_TB_O_S)
	@$(MKDIR) $(dir $@)
	$(LINK) -o $@ $^

# CREATE TEST FILE OBJECTS AND DEPENDENCY FILES BY COMPILING
$(PATH_TB_O_T)%.o: $(PATH_T)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(TEST_CFLAGS) $(CPPFLAGS) "$(@:$(PATH_TB_O_T)%.o=$(PATH_TB_D_T)%.d)" $< -o $@

# CREATE SRC FILE OBJECTS AND DEPENDENCY FILES BY COMPILING
$(PATH_TB_O_S)%.o: $(PATH_S)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(TEST_CFLAGS) $(CPPFLAGS) "$(@:$(PATH_TB_O_S)%.o=$(PATH_TB_D_S)%.d)" $< -o $@

# CREATE UNITY OBJECTS BY COMPILING
$(PATH_TB_O_U)%.o:: $(PATH_U)%.c $(PATH_U)%.h
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(TEST_CFLAGS) $< -o $@

# MAKE DEPENDENCY FILE DIRECTORY
$(ALL_DEPEND_TB):
	@$(MKDIR) $(PATH_TB)
	@$(MKDIR) $(dir $@)

# INCLUDE DEPENDENCY FILES AS COMMANDS
-include $(ALL_DEPEND_TB)

# CLEAN TEST BUILD
cleantest:
	@$(CLEANUP) $(PATH_TB)
	@echo "cleaned $(PROGRAM_NAME) test build"

# SAVE SOME FILES
.PRECIOUS: $(PATH_TB_N)%Test.$(TARGET_EXTENSION)
.PRECIOUS: $(PATH_TB_D)%.d
.PRECIOUS: $(PATH_TB_O_S)%.o
.PRECIOUS: $(PATH_TB_O_T)%.o
.PRECIOUS: $(PATH_TB_O_U)%.o
.PRECIOUS: $(PATH_TB_R)%.txt

####################
# Production Build #
####################

# ENTRY POINT
production: $(PATH_B_N)$(PROGRAM_NAME).$(TARGET_EXTENSION)

# CREATE EXECUTABLE BY LINKING OBJECTS
$(PATH_B_N)$(PROGRAM_NAME).$(TARGET_EXTENSION): $(SRC_B_O)
	@$(MKDIR) $(dir $@)
	$(LINK) -o $@ $^

# BUILD OBJECTS
$(PATH_B_O)%.o: $(PATH_S)%.c
	@$(MKDIR) $(dir $@)
	$(COMPILE) $(CFLAGS) $(CPPFLAGS) "$(@:$(PATH_B_O)%.o=$(PATH_B_D)%.d)" $< -o $@

# MAKE DEPENDENCY FILE DIRECTORY
$(DEPEND_B):
	@$(MKDIR) $(PATH_B)
	@$(MKDIR) $(dir $@)

-include $(DEPEND_B)

cleanproduction:
	@$(CLEANUP) $(PATH_B)
	@echo "cleaned $(PROGRAM_NAME) production build"

# SAVE SOME FILES
.PRECIOUS: $(PATH_B_N)$(PROGRAM_NAME).$(TARGET_EXTENSION)
.PRECIOUS: $(PATH_B_D)%.d
.PRECIOUS: $(PATH_B_O)%.o

#########
# FINAL #
#########

clean: cleantest cleanproduction
	@echo "$(PROGRAM_NAME) all clean"
