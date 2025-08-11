

help: ## displays this help message
	@awk '/^[a-zA-Z_\/-]+:.*##/ { split($$0, a, "##"); gsub(/:.*/, "", $$1); printf "\033[34m%-12s\033[0m %s\n", $$1, a[2] } /^[a-zA-Z_\/-]+:/ && !/##/ { gsub(/:.*/, "", $$1); printf "\033[34m%-12s\033[0m\n", $$1 }' $(MAKEFILE_LIST) | \
		sort | \
		grep -v '#' 
