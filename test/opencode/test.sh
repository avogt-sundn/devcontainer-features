#!/bin/bash
set -e
. dev-container-features-test-lib

check "config file exists" test -f "${REMOTE_USER_HOME}/.config/opencode/config.json"
check "config is valid JSON" python3 -c "import json; json.load(open('${REMOTE_USER_HOME}/.config/opencode/config.json'))"

reportResults
