.DEFAULT_GOAL := help

SUPPORTED_COMMANDS := contributors git linter
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMAND_ARGS):;@:)
endif

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

package-lock.json: package.json
	@npm install

node_modules: package-lock.json
	@npm install

install: node_modules ## Installation application

contributors: node_modules ## Contributors
ifeq ($(COMMAND_ARGS),add)
	@npm run contributors add
else ifeq ($(COMMAND_ARGS),check)
	@npm run contributors check
else ifeq ($(COMMAND_ARGS),generate)
	@npm run contributors generate
else
	@npm run contributors
endif

git: node_modules ## Scripts GIT
ifeq ($(COMMAND_ARGS),commit)
	@npm run commit
else ifeq ($(COMMAND_ARGS),status)
	@git status
else ifeq ($(COMMAND_ARGS),check)
	@make contributors check -i
	@make linter all -i
	@make git status -i
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make git ARGUMENT"
	@echo "---"
	@echo "commit: Commit data"
	@echo "check: CHECK before"
	@echo "status: status"
endif

linter: node_modules ## Scripts Linter
ifeq ($(COMMAND_ARGS),all)
	@make linter readme -i
else ifeq ($(COMMAND_ARGS),readme)
	@npm run linter-markdown README.md
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make linter ARGUMENT"
	@echo "---"
	@echo "all: ## Launch all linter"
	@echo "readme: linter README.md"
endif