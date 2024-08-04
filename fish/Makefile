# For fish
XDG_CONFIG_HOME ?= $(HOME)/.config

SOURCE_FILES := \
	config.fish \
	$(wildcard functions/*.fish) \
	$(wildcard completions/*.fish)

SOURCES := $(SOURCE_FILES)
TARGETS := $(addprefix $(XDG_CONFIG_HOME)/fish/,$(SOURCE_FILES))

.PHONY: help
help: ## Display this help
	@echo "Fish files:"
	@echo "  Sources: $(SOURCES)"
	@echo "  Targets: $(TARGETS)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: install
install: $(TARGETS) ## Install bash config files

$(XDG_CONFIG_HOME)/fish/% : %
	@test -d $(@D) || mkdir -pv $(@D) && \
		cp -pv $< $@

