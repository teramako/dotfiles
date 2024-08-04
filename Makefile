
ALL_TARGETS: nvim bash fish tmux

.PHONY: all
all: $(ALL_TARGETS) ## Install all

.PHONY: nvim
nvim: ## Install Neovim config files
	$(MAKE) -C nvim install

.PHONY: bash
bash: ## Install bash config files
	$(MAKE) -C bash install

.PHONY: fish
fish: ## Install fish config files
	$(MAKE) -C fish install

.PHONY: tmux
tmux: ## Install tmux config files
	$(MAKE) -C tmux install

.PHONY: help
help: ## Display this help
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' /dev/null $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":|## "}; {printf "  %-20s %s\n", $$(NF-2), $$NF}'

