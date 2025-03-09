# For curl
XDG_CONFIG_HOME ?= $(HOME)/.config

SOURCE_FILES := curlrc

SOURCES := $(SOURCE_FILES)
TARGETS := $(addprefix $(XDG_CONFIG_HOME)/,$(SOURCE_FILES))

.PHONY: help
help: ## Display this help
	@echo "curl files:"
	@echo "  Sources: $(SOURCES)"
	@echo "  Targets: $(TARGETS)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: install
install: $(TARGETS) ## Install curl config files

$(XDG_CONFIG_HOME)/% : %
	@cp -pv $< $@

