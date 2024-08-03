# Neovim
XDG_CONFIG_HOME ?= $(HOME)/.config

SOURCES := \
	init.lua \
	$(wildcard ftplugin/*.lua)

TARGETS := $(addprefix $(XDG_CONFIG_HOME)/nvim/,$(SOURCES))

.PHONY: help
help: ## Display this help
	@echo "Neovim files:"
	@echo "  Sources: $(SOURCES)"
	@echo "  Targets: $(TARGETS)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: install
install: $(TARGETS) ## Install Neovim config files

$(XDG_CONFIG_HOME)/nvim/% : %
	@test -d $(@D) || mkdir -pv $(@D) && \
		cp -pv $< $@

