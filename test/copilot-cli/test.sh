#!/bin/bash
set -e
. dev-container-features-test-lib

check "npm global list includes copilot" npm list -g @github/copilot

reportResults
