# git
XDG_CONFIG_HOME ?= $(HOME)/.config
SOURCES:= \
	config

TARGETS := $(addprefix $(XDG_CONFIG_HOME)/git/,$(SOURCES))

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

$(XDG_CONFIG_HOME)/git/% : %
	@test -d $(@D) || mkdir -pv $(@D) && \
		cp -pv $< $@

