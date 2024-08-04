# git
SOURCE_DOT_FILES := gitconfig

TARGET_DOT_FILES := $(addprefix $(HOME)/.,$(SOURCE_DOT_FILES))

SOURCES := $(SOURCE_DOT_FILES)
TARGETS := $(TARGET_DOT_FILES)

.PHONY: help
help: ## Display this help
	@echo "git files:"
	@echo "  Sources: $(SOURCES)"
	@echo "  Targets: $(TARGETS)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: install
install: $(TARGETS) ## Install bash config files

$(HOME)/.% : %
	@cp -pv $< $@

