#!/bin/bash
set -e
. dev-container-features-test-lib

check "quarkus CLI on PATH" which quarkus
check "telemetry config exists" test -f "$HOME/.redhat/io.quarkus.analytics.localconfig"
check "telemetry disabled" grep -q '"disabled":true' "$HOME/.redhat/io.quarkus.analytics.localconfig"

reportResults
