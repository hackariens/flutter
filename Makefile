.DEFAULT_GOAL := help
%:
	@:

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

package-lock.json: package.json
	npm install

node_modules: package-lock.json
	npm install

install: node_modules ## Installation application

contributors: ## Contributors
	@npm run contributors

contributors-add: ## add Contributors
	@npm run contributors add

contributors-check: ## check Contributors
	@npm run contributors check

contributors-generate: ## generate Contributors
	@npm run contributors generate

git-commit: ## Commit data
	npm run commit

git-check: ## CHECK before
	@make contributors-check -i
	@git status

linter-readme: ## linter README.md
	@npm run linter-markdown README.md
