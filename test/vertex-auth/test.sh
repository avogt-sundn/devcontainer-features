#!/bin/bash
set -e
. dev-container-features-test-lib

check "gcp config dir exists" test -d "${REMOTE_USER_HOME}/.config/gcp"
check "validate script installed" test -x /usr/local/lib/devcontainer-features/vertex-auth-validate.sh

reportResults
