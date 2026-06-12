REGISTRY  := ghcr.io
NAMESPACE := avogt-sundn/devcontainer-features
LOCK_DIR  := ../.devcontainer

FEATURES  := $(notdir $(wildcard src/*))

# Base images per feature (matches test.yaml matrix)
BASE_IMAGE_quarkus        := mcr.microsoft.com/devcontainers/java:dev-25-jdk-bookworm
BASE_IMAGE_springboot-cli := mcr.microsoft.com/devcontainers/java:dev-25-jdk-bookworm
BASE_IMAGE_opencode       := mcr.microsoft.com/devcontainers/javascript-node:22
BASE_IMAGE_playwright     := mcr.microsoft.com/devcontainers/javascript-node:22
BASE_IMAGE_claude-code    := mcr.microsoft.com/devcontainers/javascript-node:22
BASE_IMAGE_copilot-cli    := mcr.microsoft.com/devcontainers/javascript-node:22
BASE_IMAGE_default        := mcr.microsoft.com/devcontainers/base:ubuntu

base-image = $(or $(BASE_IMAGE_$(1)),$(BASE_IMAGE_default))

##
## Usage:
##   make commit              detect changed features, bump versions, commit — push triggers CI publish
##   make test FEATURE=<name> run feature test locally
##   make lock                regenerate devcontainer-lock.json in parent repo
##   make setup               install git pre-commit hook
##

.PHONY: commit test lock setup

setup:
	cp hooks/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "pre-commit hook installed"

commit:
	@set -e; \
	features=$$(git status --porcelain src/ | awk '{print $$NF}' | sed 's|src/||;s|/.*||' | grep -v '^$$' | sort -u); \
	[ -n "$$features" ] || { echo "No changes in src/."; exit 0; }; \
	bumped=; \
	for feature in $$features; do \
	  f=src/$$feature/devcontainer-feature.json; \
	  [ -f "$$f" ] || continue; \
	  cur=$$(jq -r .version "$$f"); \
	  head=$$(git show "HEAD:$$f" 2>/dev/null | jq -r .version 2>/dev/null || echo ""); \
	  if [ -n "$$head" ] && [ "$$cur" = "$$head" ]; then \
	    new=$$(echo "$$cur" | awk -F. '{print $$1"."$$2"."$$3+1}'); \
	    jq --arg v "$$new" '.version = $$v' "$$f" > "$$f.tmp" && mv "$$f.tmp" "$$f"; \
	    printf "  bumped   %s: %s → %s\n" "$$feature" "$$cur" "$$new"; \
	    cur=$$new; \
	  else \
	    printf "  kept     %s: %s\n" "$$feature" "$$cur"; \
	  fi; \
	  bumped="$${bumped:+$$bumped, }$$feature@$$cur"; \
	done; \
	git add src/; \
	git commit -m "release: $$bumped"

test:
	@[ -n "$(FEATURE)" ] || { echo "Usage: make test FEATURE=<name>"; exit 1; }
	devcontainer features test \
	  -f $(FEATURE) \
	  --base-image $(call base-image,$(FEATURE)) \
	  --skip-scenarios \
	  .

lock:
	devcontainer upgrade --workspace-folder $(LOCK_DIR)/..
