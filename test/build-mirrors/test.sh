#!/bin/bash
set -e
. dev-container-features-test-lib

check "setup script installed" test -x /usr/local/lib/devcontainer-features/build-mirrors-setup.sh
check "script contains docker compose start" grep -q "docker compose" /usr/local/lib/devcontainer-features/build-mirrors-setup.sh
check "script contains maven mirror URL" grep -q "maven-mirror:8080" /usr/local/lib/devcontainer-features/build-mirrors-setup.sh
check "script contains npm config" grep -q "npm config set" /usr/local/lib/devcontainer-features/build-mirrors-setup.sh
check "docker-compose files installed" test -f /usr/local/lib/devcontainer-features/build-mirrors/docker-compose.yaml

reportResults
