# docker
SOURCE_FILES := config.json

TARGET_FILES := $(addprefix $(HOME)/.docker/,$(SOURCE_DOT_FILES))

SOURCES := $(SOURCE_FILES)
TARGETS := $(TARGET_FILES)

.PHONY: help
help: ## Display this help
	@echo "docker files:"
	@echo "  Sources: $(SOURCES)"
	@echo "  Targets: $(TARGETS)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: install
install: $(TARGETS) ## Install bash config files

$(HOME)/.docker/% : %
	@test -d $(@D) || mkdir -pv $(@D) && \
		cp -pv $< $@

