# tmux
SOURCE_DOT_FILES := tmux.conf
TARGET_DOT_FILES := $(addprefix $(HOME)/.,$(SOURCE_DOT_FILES))

SOURCE_BIN_FILES := $(wildcard bin/*)
TARGET_BIN_FILES := $(addprefix $(HOME)/,$(SOURCE_BIN_FILES))

SOURCES := $(SOURCE_DOT_FILES) $(SOURCE_BIN_FILES)
TARGETS := $(TARGET_DOT_FILES) $(TARGET_BIN_FILES)

.PHONY: help
help: ## Display this help
	@echo "tmux files:"
	@echo "  Sources: $(SOURCES)"
	@echo "  Targets: $(TARGETS)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: install
install: $(TARGETS) ## Install bash config files

$(HOME)/.% : %
	@cp -pv $< $@

$(HOME)/bin/% : bin/%
	@test -d $(@D) || mkdir -pv $(@D) && \
		cp -pv $< $@

