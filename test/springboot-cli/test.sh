#!/bin/bash
set -e
. dev-container-features-test-lib

check "spring CLI on PATH" which spring
check "spring CLI runs" spring --version

reportResults
