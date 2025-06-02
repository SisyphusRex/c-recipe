#########################################
#		Compile Program Executable      #
#########################################

# Define source and header directories
SRC_DIR := src
INC_DIR := include
BUILD_DIR := build
TARGET := myprogram.exe

# Compiler and flags
COMPILE := gcc -c # compile but do not link: outputs .o
LINK := gcc
CFLAGS := -Wall -I$(INC_DIR)

#Source Files: recursive depth
SOURCES := $(shell find $(SRC_DIR) -name "*.c")

#Create List of objects to be created from source files
OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SOURCES))


# Compile object files.
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
# First, each object directory is created in the structure of the src directory
	@mkdir -p $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@
# -o puts

# Link object files
$(TARGET): $(OBJECTS)
	$(LINK) $(OBJECTS) -o $@

# Clean build files
clean:
	rm -rf $(BUILD_DIR)
	rm $(TARGET)


#########################################
#		Compile Test Suite  			#
#########################################

# Define directories
TEST_DIR := test
RESULTS_DIR := test_build/results
TEST_BUILD_DIR := test_build
UNITY_SRC_DIR := unity/src
UNITY_INC_DIR := unity/include
TEST_TARGET := test.exe


# Compiler and Flags
TEST_CFLAGS := -I$(UNITY_INC_DIR) -I$(INC_DIR) -D TEST -Wall


# find all test files
TEST_SOURCES := $(shell find $(TEST_DIR) -name "*.c")
UNITY_SOURCES := $(shell find $(UNITY_SRC_DIR) -name "*.c")

# Test Objects
TEST_SRC_OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(TEST_BUILD_DIR)/%.o,$(SOURCES))
TEST_UNITY_OBJECTS := $(patsubst $(UNITY_DIR)/%.c,$(TEST_BUILD_DIR)/%.o,$(UNITY_SOURCES))
TEST_SOURCES_OBJECTS := $(patsubst $(TEST_DIR)/%.c,$(TEST_BUILD_DIR)/%.o,$(TEST_SOURCES))

# Results
RESULTS := $(patsubst $(TEST_DIR)test_%.c, $(RESULTS_DIR)test_%.txt, $(TEST_SOURCES))

PASSED := `grep -s PASS $(RESULTS_DIR)*.txt`
FAIL := `grep -s FAIL $(RESULTS_DIR)*.txt`
IGNORE := `grep -s IGNORE $(RESULTS_DIR)*.txt`

test: $(TEST_BUILD_DIR) $(RESULTS_DIR)
	@echo "----------\nIGNORES:\n----------"
	@echo "$(IGNORE)"
	@echo "----------\nFAILURES:\n----------"
	@echo "$(FAIL)"
	@echo "----------\nPASSED:\n----------"
	@echo "$(PASSED)"
	@echo "\nDONE"

$(RESULTS_DIR)%.txt: TEST_TARGET
	-./$< > $@ 2>&1

# Link Object Files
$(TEST_TARGET): $(TEST_SRC_OBJECTS) $(TEST_UNITY_OBJECTS) $(TEST_SOURCES_OBJECTS)
	$(LINK) -o $@ $^


$(TEST_BUILD_DIR)/%.o: $(TEST_DIR)/%.c
	@mkdir -p $(dir $@)
	$(COMPILE) $(TEST_CFLAGS) $< -o $@

$(TEST_BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(COMPILE) $(CFLAGS) $< -o $@

$(TEST_BUILD_DIR)/%.o: $(UNITY_SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(COMPILE) $(TEST_CFLAGS) $< -o $@


$(TEST_BUILD_DIR):
	@mkdir -p $(TEST_BUILD_DIR)

$(RESULTS_DIR):
	@mkdir -p $(RESULTS_DIR)

cleantest:
	rm -rf $(TEST_BUILD_DIR)
	rm $(TEST_TARGET)