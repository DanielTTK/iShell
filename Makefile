CC	:= gcc
STD := -std=c11 -D_POSIX_C_SOURCE=200809L
WARN := -Wall -Wextra -Wpedantic
OPT ?= -O0 -g	# removes optimization, makes C closer to machine code. Also -g adds debug info to compilation output
SAN ?= -fsanitize=address,undefined # detects memory error like accessing memory after freeing or reading outside buffer
CFLAGS := $(STD) $(WARN) $(OPT) $(SAN) -fno-omit-frame-pointer -MMD -MP
LDFLAGS := $(SAN)

BUILD := build
TARGET := ishell
SRCS := $(wildcard src/*.c)
OBJS := $(SRCS:src/%.c=$(BUILD)/%.o)
LIB_OBJS := $(filter-out $(BUILD)/main.o,$(OBJS))
TESTS := $(patsubst tests/%.c,$(BUILD)/%,$(wildcard tests/tests_*.c))

.PHONY: all test test-unit test-integration clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

#$(BUILD)/%.o: src/%.c | $(BUILD) # | is a pipe, sends cmd1 output as a input to cmd2 in the following example: cmd1 | cmd2
#	$(CC) $(CFLAGS) -Isrc tests/test_$*.c $(LIB_OBJS) -o $@ $(LDFLAGS)

$(BUILD):
	mkdir -p $(BUILD)

test-unit: $(TESTS)
	@for t in $(TESTS); do echo "== $$t"; ./$$t || exit 1; done

test-integration: $(TARGET)
	./tests/run_integration.sh

test: test-unit test-integration

clean:
	rm -rf $(BUILD) $(TARGET)

-include $(OBJS: .o=.d)