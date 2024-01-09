.PHONY: default
default: help

.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Targets:"
	@echo "  ci 		  Run all CI steps"
	@echo "  lint         Run all linters"
	@echo "  lint-shellcheck Run shellcheck linter"
	@echo "  format       Run all formatters"
	@echo "  format-shellcheck Run shellcheck formatter"

.PHONY: ci
ci: lint

.PHONY: lint
lint: lint-shellcheck

SHELLCHECK_EXCLUDES := SC2012,SC2046,SC2086

.PHONY: lint-shellcheck
lint-shellcheck:
	shellcheck -e $(SHELLCHECK_EXCLUDES) *.sh

.PHONY: format
format: format-shellcheck

.PHONY: format-shellcheck
format-shellcheck:
	shellcheck -e $(SHELLCHECK_EXCLUDES) -f diff *.sh | git apply
