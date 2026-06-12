#!/bin/bash
set -e
. dev-container-features-test-lib

check "PLAYWRIGHT_BROWSERS_PATH set" test -n "$PLAYWRIGHT_BROWSERS_PATH"
check "chromium directory exists" test -d /ms-playwright
check "xvfb installed" which Xvfb

reportResults
