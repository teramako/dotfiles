# Bash
XDG_CONFIG_HOME ?= $(HOME)/.config

SOURCE_DOT_FILES := \
	profile \
	bashrc \
	inputrc
FUNCTION_FILES := $(wildcard functions/*.bash)

TARGET_DOT_FILES := $(addprefix $(HOME)/.,$(SOURCE_DOT_FILES))
TARGET_FUNCTION_FILES := $(addprefix $(XDG_CONFIG_HOME)/bash/,$(FUNCTION_FILES))

SOURCES := $(SOURCE_DOT_FILES) $(FUNCTION_FILES)
TARGETS := $(TARGET_DOT_FILES) $(TARGET_FUNCTION_FILES)

.PHONY: help
help: ## Display this help
	@echo "Bash files:"
	@echo "  Sources: $(SOURCES)"
	@echo "  Targets: $(TARGETS)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: install
install: $(TARGETS) ## Install bash config files

$(HOME)/.% : %
	@cp -pv $< $@

$(XDG_CONFIG_HOME)/bash/% : %
	@test -d $(@D) || mkdir -pv $(@D) && \
		cp -pv $< $@

