# PowerShell
XDG_CONFIG_HOME ?= $(HOME)/.config

SOURCE_FILES := \
	$(wildcard *.ps1)

TARGET_FILES := $(addprefix $(XDG_CONFIG_HOME)/powershell/,$(SOURCE_FILES))

SOURCES := $(SOURCE_FILES)
TARGETS := $(TARGET_FILES)

.PHONY: help
help: ## Display this help
	@echo "PowerShell files:"
	@echo "  Sources: $(SOURCES)"
	@echo "  Targets: $(TARGETS)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: install
install: $(TARGETS) ## Install bash config files

$(XDG_CONFIG_HOME)/powershell/% : %
	@test -d $(@D) || mkdir -pv $(@D) && \
		cp -pv $< $@


