
ALL_TARGETS: nvim bash

.PHONY: all
all: $(ALL_TARGETS) ## Install all

.PHONY: nvim
nvim: ## Install Neovim config files
	$(MAKE) -C nvim install

.PHONY: bash
bash: ## Install bash config files
	$(MAKE) -C bash install

.PHONY: help
help: ## Display this help
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' /dev/null $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":|## "}; {printf "  %-20s %s\n", $$(NF-2), $$NF}'

