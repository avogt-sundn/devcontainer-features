#!/bin/bash
set -e
. dev-container-features-test-lib

check "claude command exists" which claude
check "npm global list includes claude-code" npm list -g @anthropic-ai/claude-code

reportResults
