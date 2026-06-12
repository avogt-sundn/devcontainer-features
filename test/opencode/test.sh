#!/bin/bash
set -e
. dev-container-features-test-lib

check "config file exists" test -f "$HOME/.config/opencode/config.json"
check "config contains model key" grep -q '"model"' "$HOME/.config/opencode/config.json"
check "model placeholder replaced" bash -c "! grep -q '\${MODEL}' '$HOME/.config/opencode/config.json'"

reportResults
